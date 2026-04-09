"use client";

import { Canvas, useFrame, useThree } from "@react-three/fiber";
import { Image, ScrollControls, useScroll } from "@react-three/drei";
import { useRef, useState, useEffect, useMemo, Suspense } from "react";
import * as THREE from "three";

// ─── Showroom-style image plane ────────────────────────────────
// Each image lives on the Z axis. Scroll moves camera through them.
// Images fill the viewport, crossfade smoothly, and scale up as
// the camera passes through — like walking through a showroom.

interface ImagePlaneProps {
  url: string;
  index: number;
  total: number;
  viewportW: number;
  viewportH: number;
}

function ImagePlane({ url, index, total, viewportW, viewportH }: ImagePlaneProps) {
  const ref = useRef<THREE.Mesh>(null!);
  const scroll = useScroll();
  const prevOffset = useRef(0);

  // Fill ~85% of viewport
  const imgW = viewportW * 0.85;
  const imgH = viewportH * 0.85;
  const spacing = 3; // tighter spacing for showroom feel

  useFrame(() => {
    if (!ref.current) return;

    const scrollOffset = scroll.offset;
    const z = -index * spacing + scrollOffset * total * spacing;
    ref.current.position.z = z;

    // Velocity-based tilt (subtle)
    const velocity = scrollOffset - prevOffset.current;
    prevOffset.current = scrollOffset;
    const targetRotX = THREE.MathUtils.clamp(velocity * 8, -0.08, 0.08);
    ref.current.rotation.x = THREE.MathUtils.lerp(
      ref.current.rotation.x,
      targetRotX,
      0.08
    );

    const mat = ref.current.material as THREE.MeshBasicMaterial & {
      opacity: number;
    };

    // ── Opacity: cinematic crossfade ──
    // z > 0 : image passed camera (flying away behind us)
    // z = 0 : image at camera (full view)
    // z < 0 : image ahead (approaching)
    let opacity: number;

    if (z > 0) {
      // Passed camera — scale up + fade out quickly
      opacity = z < 0.8 ? 1 - z / 0.8 : 0;
    } else {
      const absZ = Math.abs(z);
      if (absZ < 0.3) {
        // Very close — full opacity
        opacity = 1;
      } else if (absZ < spacing * 0.7) {
        // Approaching — smooth fade in from distance
        const t = (absZ - 0.3) / (spacing * 0.7 - 0.3);
        // Ease-in-out curve for smoother transition
        opacity = 1 - t * t;
      } else {
        opacity = 0;
      }
    }
    mat.opacity = THREE.MathUtils.clamp(opacity, 0, 1);

    // ── Scale: camera pass-through effect ──
    // When image passes camera (z > 0), it scales up dramatically
    // like the camera is flying through a photograph
    let scale: number;
    if (z > 0) {
      // Passed: scale up as it recedes behind camera
      scale = 1 + z * 0.6;
    } else {
      const absZ = Math.abs(z);
      if (absZ < 0.5) {
        // At camera: slight enlarge for emphasis
        scale = 1 + (0.5 - absZ) * 0.08;
      } else {
        // Approaching: normal size (distant images appear small naturally)
        scale = 1;
      }
    }
    ref.current.scale.set(scale, scale, 1);

    // Hide distant images
    ref.current.visible = Math.abs(z) < spacing * 1.5;
  });

  return (
    <Image
      ref={ref as React.RefObject<THREE.Mesh>}
      url={url}
      scale={[imgW, imgH]}
      transparent
      position={[0, 0, -index * spacing]}
    />
  );
}

// ─── Camera rig with mouse parallax ────────────────────────────

function CameraRig() {
  const { camera, size } = useThree();
  const mouse = useRef({ x: 0, y: 0 });

  useEffect(() => {
    const onMouseMove = (e: MouseEvent) => {
      mouse.current.x = (e.clientX / size.width - 0.5) * 2;
      mouse.current.y = -(e.clientY / size.height - 0.5) * 2;
    };
    window.addEventListener("mousemove", onMouseMove, { passive: true });
    return () => window.removeEventListener("mousemove", onMouseMove);
  }, [size]);

  useFrame(() => {
    // Stronger parallax for showroom feel
    camera.position.x = THREE.MathUtils.lerp(
      camera.position.x,
      mouse.current.x * 0.5,
      0.04
    );
    camera.position.y = THREE.MathUtils.lerp(
      camera.position.y,
      mouse.current.y * 0.35,
      0.04
    );
  });

  return null;
}

// ─── Viewport-aware gallery content ────────────────────────────

interface DepthGalleryProps {
  images: string[];
}

function GalleryScene({ images }: DepthGalleryProps) {
  const { viewport } = useThree();
  const pages = Math.max(images.length * 0.6, 1);

  return (
    <ScrollControls pages={pages} damping={0.2}>
      <CameraRig />
      {/* Fog for depth atmosphere */}
      <fog attach="fog" args={["#000000", 2, 8]} />
      <ambientLight intensity={1.0} />
      {images.map((url, i) => (
        <ImagePlane
          key={i}
          url={url}
          index={i}
          total={images.length}
          viewportW={viewport.width}
          viewportH={viewport.height}
        />
      ))}
    </ScrollControls>
  );
}

// ─── Fallback grid (no WebGL) ──────────────────────────────────

function FallbackGrid({ images }: DepthGalleryProps) {
  return (
    <div className="grid grid-cols-2 lg:grid-cols-3 gap-1">
      {images.map((src, i) => (
        <div
          key={i}
          className="relative aspect-[4/3] overflow-hidden bg-bg-card"
        >
          <div
            className="absolute inset-0 bg-cover bg-center"
            style={{ backgroundImage: `url(${src})` }}
          />
        </div>
      ))}
    </div>
  );
}

// ─── Vignette overlay (CSS) ────────────────────────────────────

function Vignette() {
  return (
    <div
      className="pointer-events-none absolute inset-0 z-10"
      style={{
        background:
          "radial-gradient(ellipse at center, transparent 50%, rgba(0,0,0,0.6) 100%)",
      }}
    />
  );
}

// ─── Image counter overlay ─────────────────────────────────────

function ImageCounter({ current, total }: { current: number; total: number }) {
  return (
    <div className="absolute bottom-8 left-1/2 -translate-x-1/2 z-20 text-text-muted text-xs tracking-[0.2em] uppercase font-body">
      {current} / {total}
    </div>
  );
}

// ─── Main export ───────────────────────────────────────────────

export default function DepthGallery({ images }: DepthGalleryProps) {
  const [hasError, setHasError] = useState(false);
  const [isMounted, setIsMounted] = useState(false);

  useEffect(() => {
    setIsMounted(true);
  }, []);

  // Limit images for performance
  const displayImages = useMemo(() => images.slice(0, 20), [images]);

  if (!isMounted || hasError || displayImages.length === 0) {
    return <FallbackGrid images={displayImages} />;
  }

  return (
    <div
      style={{ height: `${Math.max(displayImages.length * 40, 250)}vh` }}
      className="relative bg-black"
    >
      <div className="sticky top-0 h-screen w-full">
        <Vignette />
        <ErrorBoundary onError={() => setHasError(true)}>
          <Suspense
            fallback={
              <div className="w-full h-full flex items-center justify-center bg-black">
                <div className="text-text-muted text-sm tracking-[0.15em] uppercase">
                  Loading Gallery...
                </div>
              </div>
            }
          >
            <Canvas
              camera={{ position: [0, 0, 3], fov: 50 }}
              gl={{ antialias: true, alpha: false }}
              style={{ background: "#000" }}
            >
              <GalleryScene images={displayImages} />
            </Canvas>
          </Suspense>
        </ErrorBoundary>
      </div>
    </div>
  );
}

// ─── Error boundary ────────────────────────────────────────────

import { Component, type ReactNode, type ErrorInfo } from "react";

interface ErrorBoundaryProps {
  children: ReactNode;
  onError: () => void;
}

interface ErrorBoundaryState {
  hasError: boolean;
}

class ErrorBoundary extends Component<ErrorBoundaryProps, ErrorBoundaryState> {
  constructor(props: ErrorBoundaryProps) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(): ErrorBoundaryState {
    return { hasError: true };
  }

  componentDidCatch(_error: Error, _info: ErrorInfo) {
    this.props.onError();
  }

  render() {
    if (this.state.hasError) {
      return null;
    }
    return this.props.children;
  }
}
