/**
 * Client-side blog utilities.
 * NOT a server action — runs on the client for zero latency.
 */

/**
 * Assemble blog sections into complete HTML with dividers between them.
 */
export function assembleBlogHtml(sections: string[]): string {
  const divider = `\n<p style="text-align:center; font-size:14px; color:#C5A572; letter-spacing:8px;">━━━ ◆ ━━━</p>\n`;
  return sections.join(divider);
}

/**
 * Fix broken image URLs in generated HTML.
 * AI sometimes truncates UUIDs in URLs. This finds broken URLs and replaces
 * them with the closest matching valid URL.
 */
export function fixImageUrls(html: string, validUrls: string[]): string {
  if (!validUrls.length) return html;

  // Extract all img src URLs from HTML
  return html.replace(
    /<img\s+[^>]*src=["']([^"']+)["']/gi,
    (fullMatch, srcUrl) => {
      // If URL is already in valid list, keep it
      if (validUrls.includes(srcUrl)) return fullMatch;

      // Try to find the closest matching valid URL
      const bestMatch = findClosestUrl(srcUrl, validUrls);
      if (bestMatch) {
        return fullMatch.replace(srcUrl, bestMatch);
      }
      return fullMatch;
    }
  );
}

/**
 * Find the closest matching URL by comparing UUID segments.
 */
function findClosestUrl(brokenUrl: string, validUrls: string[]): string | null {
  // Extract the filename from the broken URL (e.g., "001.jpg", "main.jpg")
  const brokenFilename = brokenUrl.split("/").pop() || "";

  // Extract partial UUID from broken URL
  // URLs look like: .../blacklabelled/{uuid}/{filename}
  const brokenParts = brokenUrl.split("/");
  const brokenUuidIndex = brokenParts.findIndex((p) =>
    /^[0-9a-f]{8}-/.test(p)
  );
  const brokenUuid = brokenUuidIndex >= 0 ? brokenParts[brokenUuidIndex] : "";

  let bestScore = 0;
  let bestUrl: string | null = null;

  for (const validUrl of validUrls) {
    let score = 0;

    // Filename match (most important)
    const validFilename = validUrl.split("/").pop() || "";
    if (validFilename === brokenFilename) score += 10;

    // UUID prefix match
    const validParts = validUrl.split("/");
    const validUuidIndex = validParts.findIndex((p) =>
      /^[0-9a-f]{8}-/.test(p)
    );
    const validUuid =
      validUuidIndex >= 0 ? validParts[validUuidIndex] : "";

    if (brokenUuid && validUuid) {
      // Compare UUID character by character
      const minLen = Math.min(brokenUuid.length, validUuid.length);
      let matchChars = 0;
      for (let i = 0; i < minLen; i++) {
        if (brokenUuid[i] === validUuid[i]) matchChars++;
        else break; // stop at first mismatch
      }
      score += matchChars;
    }

    if (score > bestScore) {
      bestScore = score;
      bestUrl = validUrl;
    }
  }

  // Only return if we have a reasonable match (filename + some UUID chars)
  return bestScore >= 12 ? bestUrl : null;
}
