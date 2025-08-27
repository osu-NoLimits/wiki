# :fontawesome-solid-paint-brush: Theming shiina

Create stunning custom themes for your Shiina-Web frontend! This guide walks you through the complete theming system, from basic setup to advanced customization.

!!! info "What You'll Learn"
    - :material-folder-plus: How to structure theme directories
    - :material-file-cog: Creating theme metadata and configuration
    - :material-brush: Writing custom CSS for beautiful themes  
    - :material-eye: Understanding the Halfmoon CSS framework
    - :material-cog: Advanced customization techniques

---

## :material-rocket: Quick Start

!!! tip "Prerequisites"
    - Basic knowledge of CSS and CSS variables
    - A running Shiina-Web installation
    - Text editor for code editing

### :material-folder-multiple: Theme Directory Structure

All themes are organized in the `themes/` directory with the following structure:

```
themes/
├── your-theme-name/
│   ├── theme.yml          # Theme metadata
│   └── style.css          # Theme styles
└── other-themes/
    └── ...
```

---

## :material-plus-circle: Creating a New Theme

Follow these steps to create your custom theme:

### :material-folder-plus: Step 1: Create Theme Directory

Create a new directory inside the `themes/` folder with your theme name in **lowercase**:

!!! example "Directory Example"
    ```bash
    mkdir themes/your-theme-name
    ```
    
    Replace `your-theme-name` with your desired theme name (e.g., `midnight`, `neon`, `retro`)

### :material-file-document: Step 2: Define Theme Metadata

Create a `theme.yml` file inside your theme directory:

=== ":material-file-code: theme.yml"

    ```yaml
    name: your-theme-name
    fullname: OsuNoLimits Modern
    author: halfmoon.css & osuNoLimits
    included: false
    screenshot: https://assets.osunolimits.dev/shiina/your-theme-name.png
    ```

=== ":material-information: Field Descriptions"

    | Field | Description | Required |
    |-------|-------------|----------|
    | `name` | Unique theme identifier (lowercase) | ✅ |
    | `fullname` | Display name for the theme | ✅ |
    | `author` | Theme creator(s) | ✅ |
    | `included` | Whether theme is bundled (set to `false`) | ✅ |
    | `screenshot` | Preview image URL | ❌ |

!!! warning "Important Notes"
    - The `name` field **must** match your directory name exactly
    - Always set `included: false` for custom themes
    - Use descriptive `fullname` for better user experience

### :material-brush: Step 3: Create the Style File

Create a `style.css` file with your theme styles. Here's the complete Halfmoon CSS template:

=== ":material-code-tags: Base Template"

    ```css
    /*!
     * ----------------------------------------------------------------------------
     * Halfmoon CSS - Modern theme
     * Copyright (c) 2023, Tahmid Khan | MIT License | https://www.gethalfmoon.com
     * ----------------------------------------------------------------------------
     * The above notice must be included in its entirety when this file is used.
     */
    [data-bs-core=your-theme-name] {
        /* Gray */
        --bs-slate-hue: 216;
        --bs-slate-saturation: 20%;

        /* Light gray */
        --bs-lightgray-hue: var(--bs-slate-hue);
        --bs-lightgray-saturation: var(--bs-slate-saturation);

        /* Sable (almost black) */
        --bs-sable-hue: var(--bs-darkgray-hue);
        --bs-sable-saturation: var(--bs-darkgray-saturation);
        --bs-sable-100-hsl: var(--bs-sable-hue), var(--bs-sable-saturation), 31%;
        --bs-sable-200-hsl: var(--bs-sable-hue), var(--bs-sable-saturation), 29%;
        --bs-sable-300-hsl: var(--bs-sable-hue), var(--bs-sable-saturation), 27%;
        --bs-sable-400-hsl: var(--bs-sable-hue), var(--bs-sable-saturation), 25%;
        --bs-sable-500-hsl: var(--bs-sable-hue), var(--bs-sable-saturation), 23%;
        --bs-sable-600-hsl: var(--bs-sable-hue), var(--bs-sable-saturation), 21%;
        --bs-sable-700-hsl: var(--bs-sable-hue), var(--bs-sable-saturation), 19%;
        --bs-sable-800-hsl: var(--bs-sable-hue), var(--bs-sable-saturation), 17%;
        --bs-sable-900-hsl: var(--bs-sable-hue), var(--bs-sable-saturation), 15%;
        --bs-sable-100: hsl(var(--bs-sable-100-hsl));
        --bs-sable-200: hsl(var(--bs-sable-200-hsl));
        --bs-sable-300: hsl(var(--bs-sable-300-hsl));
        --bs-sable-400: hsl(var(--bs-sable-400-hsl));
        --bs-sable-500: hsl(var(--bs-sable-500-hsl));
        --bs-sable-600: hsl(var(--bs-sable-600-hsl));
        --bs-sable-700: hsl(var(--bs-sable-700-hsl));
        --bs-sable-800: hsl(var(--bs-sable-800-hsl));
        --bs-sable-900: hsl(var(--bs-sable-900-hsl));
        --bs-sable-hsl: var(--bs-sable-500-hsl);
        --bs-sable: hsl(var(--bs-sable-hsl));
        --bs-sable-foreground-hsl: var(--bs-white-hsl);
        --bs-sable-foreground: hsl(var(--bs-sable-foreground-hsl));
        --bs-sable-text-emphasis-hsl: var(--bs-sable-600-hsl);
        --bs-sable-text-emphasis: hsl(var(--bs-sable-text-emphasis-hsl));
        --bs-sable-hover-bg: var(--bs-sable-600);
        --bs-sable-active-bg: var(--bs-sable-700);
        --bs-sable-bg-subtle: hsl(var(--bs-sable-hue), var(--bs-sable-saturation), 70%);
        --bs-sable-border-subtle: var(--bs-sable-400);
        --bs-sable-checkbox-svg: var(--bs-checkbox-svg-light);
        --bs-sable-dash-svg: var(--bs-dash-svg-light);
        --bs-sable-radio-svg: var(--bs-radio-svg-light);
        --bs-sable-switch-svg: var(--bs-switch-svg-light);

        /* Primary */
        --bs-primary-hue: var(--bs-navy-hue);
        --bs-primary-saturation: var(--bs-navy-saturation);
        --bs-primary-100-hsl: var(--bs-navy-100-hsl);
        --bs-primary-200-hsl: var(--bs-navy-200-hsl);
        --bs-primary-300-hsl: var(--bs-navy-300-hsl);
        --bs-primary-400-hsl: var(--bs-navy-400-hsl);
        --bs-primary-500-hsl: var(--bs-navy-500-hsl);
        --bs-primary-600-hsl: var(--bs-navy-600-hsl);
        --bs-primary-700-hsl: var(--bs-navy-700-hsl);
        --bs-primary-800-hsl: var(--bs-navy-800-hsl);
        --bs-primary-900-hsl: var(--bs-navy-900-hsl);
        --bs-primary-100: var(--bs-navy-100);
        --bs-primary-200: var(--bs-navy-200);
        --bs-primary-300: var(--bs-navy-300);
        --bs-primary-400: var(--bs-navy-400);
        --bs-primary-500: var(--bs-navy-500);
        --bs-primary-600: var(--bs-navy-600);
        --bs-primary-700: var(--bs-navy-700);
        --bs-primary-800: var(--bs-navy-800);
        --bs-primary-900: var(--bs-navy-900);
        --bs-primary-hsl: var(--bs-navy-hsl);
        --bs-primary: var(--bs-navy);
        --bs-primary-foreground-hsl: var(--bs-navy-foreground-hsl);
        --bs-primary-foreground: var(--bs-navy-foreground);
        --bs-primary-text-emphasis-hsl: var(--bs-navy-text-emphasis-hsl);
        --bs-primary-text-emphasis: var(--bs-navy-text-emphasis);
        --bs-primary-hover-bg: var(--bs-navy-hover-bg);
        --bs-primary-active-bg: var(--bs-navy-active-bg);
        --bs-primary-bg-subtle: var(--bs-navy-bg-subtle);
        --bs-primary-border-subtle: var(--bs-navy-border-subtle);
        --bs-primary-checkbox-svg: var(--bs-navy-checkbox-svg);
        --bs-primary-dash-svg: var(--bs-navy-dash-svg);
        --bs-primary-radio-svg: var(--bs-navy-radio-svg);
        --bs-primary-switch-svg: var(--bs-navy-switch-svg);

        /* Info */
        --bs-info-hue: var(--bs-blue-hue);
        --bs-info-saturation: var(--bs-blue-saturation);
        --bs-info-100-hsl: var(--bs-blue-100-hsl);
        --bs-info-200-hsl: var(--bs-blue-200-hsl);
        --bs-info-300-hsl: var(--bs-blue-300-hsl);
        --bs-info-400-hsl: var(--bs-blue-400-hsl);
        --bs-info-500-hsl: var(--bs-blue-500-hsl);
        --bs-info-600-hsl: var(--bs-blue-600-hsl);
        --bs-info-700-hsl: var(--bs-blue-700-hsl);
        --bs-info-800-hsl: var(--bs-blue-800-hsl);
        --bs-info-900-hsl: var(--bs-blue-900-hsl);
        --bs-info-100: var(--bs-blue-100);
        --bs-info-200: var(--bs-blue-200);
        --bs-info-300: var(--bs-blue-300);
        --bs-info-400: var(--bs-blue-400);
        --bs-info-500: var(--bs-blue-500);
        --bs-info-600: var(--bs-blue-600);
        --bs-info-700: var(--bs-blue-700);
        --bs-info-800: var(--bs-blue-800);
        --bs-info-900: var(--bs-blue-900);
        --bs-info-hsl: var(--bs-blue-hsl);
        --bs-info: var(--bs-blue);
        --bs-info-foreground-hsl: var(--bs-blue-foreground-hsl);
        --bs-info-foreground: var(--bs-blue-foreground);
        --bs-info-text-emphasis-hsl: var(--bs-blue-text-emphasis-hsl);
        --bs-info-text-emphasis: var(--bs-blue-text-emphasis);
        --bs-info-hover-bg: var(--bs-blue-hover-bg);
        --bs-info-active-bg: var(--bs-blue-active-bg);
        --bs-info-bg-subtle: var(--bs-blue-bg-subtle);
        --bs-info-border-subtle: var(--bs-blue-border-subtle);
        --bs-info-checkbox-svg: var(--bs-blue-checkbox-svg);
        --bs-info-dash-svg: var(--bs-blue-dash-svg);
        --bs-info-radio-svg: var(--bs-blue-radio-svg);
        --bs-info-switch-svg: var(--bs-blue-switch-svg);
    }
    [data-bs-core=your-theme-name][data-bs-theme=dark] {
        /* Dark gray */
        --bs-darkgray-text-emphasis-hsl: var(--bs-darkgray-200-hsl);
        --bs-darkgray-text-emphasis: hsl(var(--bs-darkgray-text-emphasis-hsl));

        /* Sable (black) */
        --bs-sable-text-emphasis-hsl: var(--bs-sable-400-hsl);
        --bs-sable-text-emphasis: hsl(var(--bs-sable-text-emphasis-hsl));
        --bs-sable-bg-subtle: hsl(var(--bs-sable-hue), var(--bs-sable-saturation), 14%);
        --bs-sable-border-subtle: var(--bs-sable-600);

        /* Blue */
        --bs-blue-text-emphasis-hsl: var(--bs-blue-300-hsl);
        --bs-blue-text-emphasis: hsl(var(--bs-blue-text-emphasis-hsl));

        /* Primary */
        --bs-primary-hue: var(--bs-sky-hue);
        --bs-primary-saturation: var(--bs-sky-saturation);
        --bs-primary-100-hsl: var(--bs-sky-100-hsl);
        --bs-primary-200-hsl: var(--bs-sky-200-hsl);
        --bs-primary-300-hsl: var(--bs-sky-300-hsl);
        --bs-primary-400-hsl: var(--bs-sky-400-hsl);
        --bs-primary-500-hsl: var(--bs-sky-500-hsl);
        --bs-primary-600-hsl: var(--bs-sky-600-hsl);
        --bs-primary-700-hsl: var(--bs-sky-700-hsl);
        --bs-primary-800-hsl: var(--bs-sky-800-hsl);
        --bs-primary-900-hsl: var(--bs-sky-900-hsl);
        --bs-primary-100: var(--bs-sky-100);
        --bs-primary-200: var(--bs-sky-200);
        --bs-primary-300: var(--bs-sky-300);
        --bs-primary-400: var(--bs-sky-400);
        --bs-primary-500: var(--bs-sky-500);
        --bs-primary-600: var(--bs-sky-600);
        --bs-primary-700: var(--bs-sky-700);
        --bs-primary-800: var(--bs-sky-800);
        --bs-primary-900: var(--bs-sky-900);
        --bs-primary-hsl: var(--bs-sky-hsl);
        --bs-primary: var(--bs-sky);
        --bs-primary-foreground-hsl: var(--bs-sky-foreground-hsl);
        --bs-primary-foreground: var(--bs-sky-foreground);
        --bs-primary-text-emphasis-hsl: var(--bs-sky-text-emphasis-hsl);
        --bs-primary-text-emphasis: var(--bs-sky-text-emphasis);
        --bs-primary-hover-bg: var(--bs-sky-hover-bg);
        --bs-primary-active-bg: var(--bs-sky-active-bg);
        --bs-primary-bg-subtle: var(--bs-sky-bg-subtle);
        --bs-primary-border-subtle: var(--bs-sky-border-subtle);
        --bs-primary-checkbox-svg: var(--bs-sky-checkbox-svg);
        --bs-primary-dash-svg: var(--bs-sky-dash-svg);
        --bs-primary-radio-svg: var(--bs-sky-radio-svg);
        --bs-primary-switch-svg: var(--bs-sky-switch-svg);

        /* Info */
        --bs-info-text-emphasis-hsl: var(--bs-blue-text-emphasis-hsl);
        --bs-info-text-emphasis: var(--bs-blue-text-emphasis);
        --bs-info-bg-subtle: var(--bs-blue-bg-subtle);
        --bs-info-border-subtle: var(--bs-blue-border-subtle);
    }
    /* Variables */
    [data-bs-core=your-theme-name] {
        /* Link */
        --bs-link-color-hsl: var(--bs-info-text-emphasis-hsl);
        --bs-link-hover-color-hsl: var(--bs-info-hsl);

        /* Content (used as needed in cards, panels, menus, etc.) */
        --bs-content-bg-hsl: var(--bs-body-bg-hsl);
        --bs-content-border-color: var(--bs-border-color);

        /* Form */
        --bs-form-focus-border-color: var(--bs-info-border-subtle);
        --bs-form-focus-shadow-hsl: var(--bs-info-hsl);
        --bs-form-check-focus-border-color: var(--bs-info-border-subtle);
    }

    [data-bs-core=your-theme-name]:not([data-bs-theme=dark]) {
        /* Background */
        --bs-body-bg-hsl: var(--bs-white-hsl);
        --bs-secondary-bg-hsl: var(--bs-lightgray-hue), var(--bs-lightgray-saturation), 98.75%;
        --bs-tertiary-bg-hsl: var(--bs-lightgray-hue), var(--bs-lightgray-saturation), 97.5%;

        /* Border */
        --bs-border-color: var(--bs-lightgray-700);
        --bs-border-color-light: var(--bs-lightgray-500);
    }

    [data-bs-core=your-theme-name][data-bs-theme=dark] {
        /* Background */
        --bs-body-bg-hsl: var(--bs-sable-900-hsl);
        --bs-secondary-bg-hsl: var(--bs-sable-800-hsl);
        --bs-tertiary-bg-hsl: var(--bs-sable-700-hsl);

        /* Border */
        --bs-border-color: var(--bs-gray-900);

        /* Content (used as needed in cards, panels, menus, etc.) */
        --bs-content-floating-bg-hsl: var(--bs-sable-hue), var(--bs-sable-saturation), 16.5%;

        /* Action (used as needed in buttons, inputs, menu items, page links, etc.) */
        --bs-action-border-color: var(--bs-border-color);

        /* Contextual buttons */
        --bs-ctx-btn-border-color: transparent;
        --bs-ctx-btn-bg-clip: border-box;

        /* Action bar (used as needed in range, progress, etc.) */
        --bs-actionbar-border-color: hsla(var(--bs-white-hsl), 0.075);
        --bs-progresstrack-border-width: 0;
        --bs-progresstrack-box-shadow: inset 0 0 0 var(--bs-border-width) var(--bs-actionbar-border-color);
        --bs-progresstrack-bg-clip: border-box;
    }

    /* Sidebar */
    [data-bs-core=your-theme-name] .sidebar {
        --bs-sidebar-item-padding-x: 1rem;
        --bs-sidebar-item-padding-y: 0.25rem;
        --bs-sidebar-header-font-weight: var(--bs-font-weight-bold);
        --bs-sidebar-divider-bg: var(--bs-sidebar-bg);
    }

    [data-bs-core=your-theme-name] .sidebar-nav .nav-link {
        border-left: var(--bs-border-width) solid var(--bs-border-color-light);
    }

    [data-bs-core=your-theme-name] .sidebar-nav .nav-link.active,
    [data-bs-core=your-theme-name] .sidebar-nav .nav-link.show {
        font-weight: var(--bs-font-weight-bold);
        border-color: currentColor;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
    }
    ```

---

## :material-cog: Advanced Customization

### :material-format-paint: Custom Element Styling

Target specific Shiina components by replacing `your-theme-name` with your theme name:

!!! example "Search Input Styling"

    ```css
    [data-bs-core=your-theme-name] .shiina-search-input {
        padding: 10px;
        border-radius: 8px;
        background: var(--bs-secondary-bg);
        border: 2px solid var(--bs-primary);
        transition: all 0.3s ease;
    }

    [data-bs-core=your-theme-name] .shiina-search-input:focus {
        box-shadow: 0 0 15px var(--bs-primary);
        transform: scale(1.02);
    }
    ```

### :material-palette-swatch: Color Scheme Examples

=== ":material-weather-night: Dark Cyberpunk"

    ```css
    [data-bs-core=cyberpunk] {
        --bs-primary-hue: 300;
        --bs-primary-saturation: 80%;
        --bs-info-hue: 180;
        --bs-info-saturation: 90%;
        --bs-body-bg-hsl: 230, 25%, 8%;
    }
    ```

=== ":material-weather-sunny: Light Pastel"

    ```css
    [data-bs-core=pastel] {
        --bs-primary-hue: 320;
        --bs-primary-saturation: 45%;
        --bs-info-hue: 200;
        --bs-info-saturation: 60%;
        --bs-body-bg-hsl: 45, 85%, 97%;
    }
    ```

=== ":material-leaf: Nature Theme"

    ```css
    [data-bs-core=nature] {
        --bs-primary-hue: 120;
        --bs-primary-saturation: 65%;
        --bs-info-hue: 60;
        --bs-info-saturation: 75%;
        --bs-body-bg-hsl: 90, 20%, 96%;
    }
    ```

---

## :material-lightbulb: Best Practices

!!! tip "Theme Development Tips"
    - :material-eye-check: **Test both light and dark modes** - Ensure your theme works well in both themes
    - :material-responsive: **Consider mobile responsiveness** - Test on different screen sizes
    - :material-contrast: **Maintain accessibility** - Ensure proper color contrast ratios
    - :material-speedometer: **Optimize performance** - Avoid unnecessary CSS rules and complex selectors

!!! note "CSS Variable Guidelines"
    - Use HSL values for better color manipulation
    - Leverage existing Halfmoon variables when possible
    - Keep color palettes consistent across components
    - Document your custom variables for maintenance

### :material-file-check: Theme Validation

Before publishing your theme, verify:

- [x] `theme.yml` contains all required fields
- [x] CSS selectors use your theme name correctly
- [x] Dark mode variants are included
- [x] Theme displays correctly in Shiina admin panel
- [x] All interactive elements are properly styled

---

## :material-share: Publishing Your Theme

Once your theme is complete:

1. **Test thoroughly** in your Shiina installation
2. **Create documentation** for any special features
3. **Share with the community** via GitHub or Discord
4. **Consider submitting** to the official theme collection

!!! success "Congratulations!"
    You've successfully created a custom Shiina theme! Your users will now be able to enjoy a personalized experience with your unique design.

---

## :material-frequently-asked-questions: FAQ

??? question "Can I modify existing themes?"
    Yes! You can use any existing theme as a starting point. Just copy the theme directory, rename it, and modify the files as needed.
    This doesn't apply to marketplace themes

??? question "How do I debug theme issues?"
    Use your browser's developer tools to inspect CSS variables and see which rules are being applied. The theme name in CSS selectors must match exactly.

??? question "Are there any performance considerations?"
    Keep CSS rules efficient and avoid deeply nested selectors. The Halfmoon framework is already optimized, so building on top of it ensures good performance.

??? question "Can themes modify JavaScript functionality?"
    Themes are CSS-only. For JavaScript modifications, you'll need to use the plugin system instead.