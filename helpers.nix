let

  range =
    # First integer in the range
    first:
    # Last integer in the range
    last:
    if first > last then
      []
    else
      builtins.genList (n: first + n) (last - first + 1);

  stringToCharacters = s:
    map (p: builtins.substring p 1 s) (range 0 (builtins.stringLength s - 1));

  concatStrings = builtins.concatStringsSep "";

  charactersToString = concatStrings;

  reverse = cs:
    if cs == [] then []
    else (reverse (builtins.tail cs)) ++ [(builtins.head cs)];
  isWhitespace = c : c == " " || c == "\t" || c == "\n";
  rtrim = cs: if isWhitespace (builtins.head cs) then rtrim (builtins.tail cs) else cs;
  ltrim = cs: reverse (rtrim (reverse cs));
  ctrim = cs: ltrim (rtrim cs);
  trim = str: charactersToString (ctrim (stringToCharacters str));
  over = ch: (import ch) { overlays = [ ]; };
  channelFromRevision = revision : over (fetchTarball "https://github.com/NixOS/nixpkgs/archive/${revision}.tar.gz");
in {
  inherit
    trim
    channelFromRevision;
}
