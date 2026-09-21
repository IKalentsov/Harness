# UI and accessibility

## Mandatory screen states

Every screen with asynchronous data implements **four** states, even when "empty never
happens":

| State | Requirement |
|---|---|
| Loading | A skeleton or spinner in place of the content, with no layout shift; a refetch does not reset the screen |
| Empty | A "nothing found" text plus what to change in the query; never a blank white screen |
| Error | A clear message and a retry action; technical detail goes to the log, not to the user |
| Success | The data; a partial result is handled separately from an error |

Cross-cutting states: "no access" (where authorisation exists) and "partial load" — show what
arrived, marked as partial.

## Accessibility (WCAG 2.2 AA — mandatory)

- **Semantics:** `<button>` for actions, `<a>` for navigation, `<label>` for inputs.
- **Keyboard:** everything interactive is reachable by Tab, focus is visible, and the focus
  order matches the visual one.
- **Forms:** an error is tied to its field and announced; required fields and formats are
  declared.
- **Asynchronous results:** the changing container is marked as a polite live region so the
  result is announced.
- **Images:** meaningful ones carry a text alternative, decorative ones carry an empty one.
  Icon-only buttons carry a screen-reader label.
- **Interactive targets** are at least 24×24 CSS px.
- **Contrast** of text and controls meets AA; it is checked against a checklist, not by eye.

## Styling

- Utilities and theme tokens only. A per-component CSS file, inline styles and direct DOM
  manipulation are out.
- Colours, spacing and radii come from tokens: hard-coded values and `!important` are out.
- Dark theme and responsiveness are part of the design system, not a separate "later" task.
