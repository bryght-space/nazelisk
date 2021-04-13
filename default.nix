with (import ./helpers.nix);
let
  getByRevision = revision: name: builtins.getAttr name (channelFromRevision revision);
  revisions = {
    "4.0.0" = ["810d22fb35287e14125470e3b917b90488ae5ed5" "bazel_4"];
    "3.7.2" = ["0b9f90ef5f2c5dabafa12e8d8a5e549ad901149e" "bazel_3"];
    "3.7.1" = ["71cda4f1118d41db29e50077fb8611f9ac472b8e" "bazel_3"];
  };
 # 
  getByVersion = version :
    let
      p        = builtins.getAttr version revisions;
      revision = builtins.elemAt p 0;
      name     = builtins.elemAt p 1;
    in
      getByRevision revision name;
in path : getByVersion (trim (builtins.readFile (toString "${toString path}/.bazelversion")))
