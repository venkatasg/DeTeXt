# DeTeXt

<p align="center">
<img style="width:33%"
  src = "https://venkatasg.net/files/apps/detext/Icon.png"
  alt = "DeTeXt icon."
/>
</p>

<p align="center">
<a href="https://apps.apple.com/us/app/id1531906207">
    <picture>
          <source
            srcset="https://venkatasg.net/files/apps/badges/ios-white.svg"
            media="(prefers-color-scheme: dark)">
        <img
          src = "https://venkatasg.net/files/apps/badges/ios-black.svg"
          alt = "Download DeTeXt on the iOS App Store."
        />
    </picture>
</a>

<a href="https://apps.apple.com/us/app/detext/id1531906207">
    <picture>
          <source
            srcset="https://venkatasg.net/files/apps/badges/mac-white.svg"
            media="(prefers-color-scheme: dark)">
        <img
          src = "https://venkatasg.net/files/apps/badges/mac-black.svg"
          alt = "Download DeTeXt on the Mac App Store."
        />
    </picture>
</a>
</p>

Finding the symbol you want to use in LaTeX can be hard since you can't memorize
all the possible commands and packages for every symbol you might need to use
in your document. DeTeXt tries to solve this problem by giving you two ways to
find the command you want:

- Draw the symbol you want and DeTeXt's neural image classification engine will
 identify what it thinks are the 20 most likely LaTeX symbols that look like
 the one you drew, arranged in order of decreasing confidence.

- Search the entire symbol set within the app, even if you only remember part
of the name of the symbol and/or command. The app has 1098 symbols including
all default mathematical symbols, and symbols from packages like tipa, amsmath,
amssymb, textcomp and more.

DeTeXt was built using SwiftUI, PencilKit, CoreML and Combine.

Code used to generate drawings, figures and the image classification model can
be found in the [supplementary repository](https://github.com/venkatasg/DeTeXt-Supplementary)
