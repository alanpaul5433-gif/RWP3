# Design System Document: The Kinetic Pulse

## 1. Overview & Creative North Star: "Velocity Editorial"
This design system moves away from the static, utilitarian nature of traditional transit apps. Our Creative North Star is **Velocity Editorial**. We treat every screen like a high-end fashion or automotive spread—dynamic, asymmetric, and deeply intentional. 

Instead of a standard grid of boxes, we utilize "Breathing Room" and "Layered Momentum." We break the "template" look by overlapping typography over image containers and using a high-contrast scale that prioritizes speed of comprehension and emotional energy. The system is designed to feel like it’s in motion even when the user is standing still.

---

## 2. Colors: Tonal Energy & The "No-Line" Rule
Our palette is anchored by the high-energy `primary` (#b7102a), but it is the sophisticated interplay of surfaces that defines the premium feel.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders to section content. Boundaries must be defined solely through:
- **Background Shifts:** Placing a `surface-container-low` card on a `surface` background.
- **Tonal Transitions:** Using subtle shifts in the surface tier to imply containment.

### Surface Hierarchy & Nesting
We treat the UI as a series of physical layers. To create depth without clutter:
- **Base:** `surface` (#f3fcf0) for the main application background.
- **Secondary Content:** `surface-container` (#e7f0e5) for secondary sections or sidebars.
- **Elevated Focus:** `surface-container-lowest` (#ffffff) for primary cards to create a "lifted" effect.
- **The Glass & Gradient Rule:** For floating action buttons or high-priority ETA cards, use a backdrop-blur (20px+) with a semi-transparent `surface-variant`. Apply a subtle linear gradient from `primary` to `primary-container` on main CTAs to give them "soul" and a tactile, curved appearance.

---

## 3. Typography: The Authority of Scale
We utilize a pairing of **Plus Jakarta Sans** for high-impact display moments and **Inter** for precision data.

*   **Display (Plus Jakarta Sans):** Used for "Hero" moments like "Where to?" or "Driver Arriving." The `display-lg` (3.5rem) should feel unapologetically large, driving the high-energy personality.
*   **Headlines (Plus Jakarta Sans):** `headline-md` (1.75rem) provides the editorial structure.
*   **Body & Labels (Inter):** All functional data—prices, car models, and plate numbers—must use Inter. This ensures "Reliability" and "Clarity" at high speeds. 

**Editorial Note:** Use `headline-lg` with tight letter-spacing (-0.02em) to create a modern, "compressed" energy in the dark mode headers.

---

## 4. Elevation & Depth: Tonal Layering
We eschew traditional drop shadows for **Tonal Layering**.

*   **The Layering Principle:** Place a `surface-container-lowest` card on a `surface-container-low` section. The subtle difference in hex code creates a natural, soft lift that feels "built-in" rather than "pasted on."
*   **Ambient Shadows:** If a floating element (like a map pin or a floating "Request" bar) requires a shadow, it must be an **Ambient Shadow**: `offset: 0 12px`, `blur: 24px`, `color: on-surface` at **6% opacity**. 
*   **The "Ghost Border" Fallback:** If a container sits on a background of the same color, use a `outline-variant` token at **15% opacity**. Never use a 100% opaque border.
*   **Glassmorphism:** Use for the top navigation bar and map overlays. A 70% opacity `surface` with a 32px backdrop blur ensures the map "bleeds" through the UI, creating an integrated, high-end environmental feel.

---

## 5. Components: Precision Primitives

### Buttons (The Kinetic Trigger)
*   **Primary:** Background: `primary` (#b7102a); Text: `on-primary` (#ffffff). **Radius: 12px (md)**. Use a subtle inner-glow (white at 10% opacity) on the top edge to simulate a premium tactile finish.
*   **Secondary:** Background: `secondary-container`; Text: `on-secondary-container`. No border.

### Input Fields (The Active Search)
*   Forbid "Boxy" inputs. Use a `surface-container-high` background with a `full` (9999px) roundness for the destination search bar to imply "Flow." 
*   **Active State:** Shift background to `surface-container-lowest` and apply the Ambient Shadow.

### Cards & Lists (The Editorial Feed)
*   **Strict Rule:** No dividers. Separate ride options using `1.5rem (6)` of vertical white space or a subtle background shift from `surface` to `surface-container-low`.
*   **Ride Options:** Use asymmetric layouts—car image slightly overlapping the card boundary to create a sense of "Leaping Forward."

### Map Overlays (The Floating HUD)
*   Floating widgets for "Current Location" or "SOS" must use the **Glassmorphism** rule. This maintains the "Modern" and "Engaging" personality while keeping the focus on the map.

---

## 6. Do’s and Don'ts

### Do:
*   **Do** use extreme scale. If an ETA is the most important thing, make it `display-md` size.
*   **Do** use "Breathing Room." Let the `surface` color dominate the screen to convey a premium, uncluttered experience.
*   **Do** ensure all interactive elements use the **12px (md)** or **Full** roundness scale to maintain the modern, approachable feel.

### Don't:
*   **Don't** use black (#000000) for text. Always use `on-surface` (#161d16) to keep the "Pure White" background looking crisp and high-end.
*   **Don't** use standard Material Design "Card Shadows." If the tonal shift isn't enough, your layout isn't intentional enough.
*   **Don't** use dividers in lists. If the content feels messy without a line, use more whitespace (Scale 8 or 10).

---

## 7. Token Reference Summary

| Token | Value | Role |
| :--- | :--- | :--- |
| `primary` | #b7102a | Action/Energy |
| `secondary` | #485f84 | Professionalism/Trust |
| `surface` | #f3fcf0 | Main Canvas |
| `surface-container` | #e7f0e5 | Secondary Layer |
| `radius-md` | 12px | Signature Component Curves |
| `spacing-6` | 1.5rem | Standard Gutter |