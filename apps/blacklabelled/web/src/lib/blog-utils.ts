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
