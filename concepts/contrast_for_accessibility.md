# Contrast for Accessibility

## Contrast standards

Google Accessibility Rating (GAR) are a set of guidelines for ensuring digital
products are accessible to people with disabilities. Color contrast is a
critical component of GAR compliance.

For web apps, this means adhering to WCAG’s contrast ratio recommendations.
Sufficient contrast is vital in cases where we aim to make content easily
readable for all users, including those with visual impairments. This can be
achieved by using colors that provide enough contrast between the text and
background.

### Contrast ratio

Color contrast ratio refers to the difference in tone or lightness, without
considering the hue or chroma. A helpful way to think about a user interface
with good contrast ratios is that it remains functional even in its gray-scale
format.

Contrast ratio is based on `Y`, a component in the CIEXYZ color space that
measures brightness. `Y` is in a one-to-one relationship with `L*` from CIELab.
Given two colors where the lighter color's `Y` is `yL` and the darker color's
`Y` is `yD`, the contrast ratio is defined as:

```
contrast_ratio = (yL + 5.0) / (yD + 5.0)
```

Examples:

-   The contrast ratio between a color and itself is 1.0.
-   The contrast ratio between black and white is 21.0.
-   Contrast ratios can range from 1 to 21 (commonly written 1:1 to 21:1), think
    black text on a white background.

When we say "not enough contrast", it means that the contrast ratio between the
background and foreground colors is not sufficiently high for a threshold. For
example, a difference of 40 in tone guarantees a WCAG contrast ratio ≥ 3.0; a
difference of 50 in tone guarantees a contrast ratio ≥ 4.5. Generally, text is
considered legible against a background when the two colors have a contrast
ratio of at least 4.5.

## How MCU schemes comply GAR/WCAG

The color schemes for default, medium and high contrast levels are designed
according to various contrast ratios specified at each level for text and
non-text elements. These contrast ratios operate in two ways:

-   **Guaranteed minimum contrast ratios**: defined based on GAR/WCAG standards.
    Colors meet or exceed these ratios on the relevant UI elements.

-   **Discretionary contrast ratios**: defined based on desirable visual design.
    Colors approach these ratios on the relevant UI elements. Because of the
    physical limits of color, it may be impossible for those colors to reach or
    exceed these ratios, which is why they operate as targets rather than
    guaranteed minimums.

#### Default contrast

-   Meets AA accessibility level

    -   **Guaranteed minimum contrast ratios:**

        -   4.5:1 for all text and icons
        -   3:1 for required non-text elements (GAR/WCAG standards allow certain
            non-text elements to fall below 3:1 contrast based on other design
            criteria)

    -   **Discretionary contrast ratios:**

        -   7:1 for higher emphasis text

#### Medium contrast

-   Exceeds AA accessibility level

    -   **Guaranteed minimum contrast ratios:**

        -   4.5:1 for all text and icons
        -   3:1 for all non-text elements, including those not required to meet
            3:1

    -   **Discretionary contrast ratios:**

        -   7:1 for text
        -   11:1 for higher emphasis text

#### High contrast

-   Meets AAA accessibility level

    -   **Guaranteed minimum contrast ratios:**

        -   7:1 for all text and icons
        -   4.5:1 for all non-text elements

    -   **Discretionary contrast ratios:**

        -   11:1 for text
        -   21:1 for higher emphasis text

## How MCU derives schemes for accessibility

MCU achieves GAR/WCAG compliance through:

-   **Color Roles:** Assigning semantic roles to colors (e.g., primary,
    secondary, background) ensures accessibility. The color system is built on
    accessible color pairings; MCU measures the contrast ratio between adjacent
    colors or overlaid colors (foreground / background) and adjusts them
    accordingly to meet the required contrast ratio. These color pairs provide
    an accessible minimum of 3:1 contrast.

-   **Contrast libraries:** These libraries provide pre-defined color palettes
    and algorithms to adjust tone of the of colors in the pair to reach the
    target contrast ratio.
