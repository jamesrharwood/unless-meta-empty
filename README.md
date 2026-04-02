# Unless-meta-empty Extension For Quarto

_TODO_: Add a short description of your extension.

A quarto filter to only render content when metadata includes a key. Unlike Quarto's native 'when-meta' shortcode, which will only return true when a yaml value is `true`, this filter will return true as long as the key is present and has any value. This means it will return true if the value is a string.

## Installing

```bash
quarto add jamesrharwood/unless-meta-empty
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

Then add the filter to `_quarto.yml`

```{yaml}
format:
  html:
    filters:
      - jamesrharwood/unless-meta-empty
````

## Using

```{markdown}
---
title: Example
subtitle: My subtitle
---

::: {unless-meta-empty=true key="subtitle"}
## Subtitle block

This appears because `subtitle` exists and is not blank.
:::
```
