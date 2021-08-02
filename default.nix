with (import ./helpers.nix);
let
  getByRevision = revision: name: builtins.getAttr name (channelFromRevision revision);
  revisions = {
    "4.0.0" = ["d4590d21006387dcb190c516724cb1e41c0f8fdf" "bazel_4" "jdk11" ];
    "3.7.2" = ["0b9f90ef5f2c5dabafa12e8d8a5e549ad901149e" "bazel_3" "jdk8"  ];
    "3.7.1" = ["71cda4f1118d41db29e50077fb8611f9ac472b8e" "bazel_3" "jdk8"  ];
  };
 # 
  getByVersion = version :
    let
      p        = builtins.getAttr version revisions;
      revision = builtins.elemAt p 0;
      items    = builtins.tail p;
      f        = n: getByRevision revision n;
    in
      builtins.map f items;
in path : getByVersion (trim (builtins.readFile (toString "${toString path}/.bazelversion")))
