{pkgs, ...}:
pkgs.writers.writeBabashkaBin "lastdl-bb" {}
# clj
''
  (require '[babashka.fs :as fs])

  (fs/list-dir "/home/lpchaim/Downloads/")
''
