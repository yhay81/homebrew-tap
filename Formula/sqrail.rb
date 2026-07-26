class Sqrail < Formula
  desc "Minimal SQL-on-files CLI for coding agents"
  homepage "https://yhay81.github.io/sqrail/"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yhay81/sqrail/releases/download/v0.2.0/sqrail-v0.2.0-macos-arm64.tar.gz"
      sha256 "ca31f80a68a2b4a9935ab9e03350a14d9b007c8baa9afc15337a0003c306f3aa"
    end

    on_intel do
      url "https://github.com/yhay81/sqrail/releases/download/v0.2.0/sqrail-v0.2.0-macos-x86_64.tar.gz"
      sha256 "ebae43814503a6941748eb2cf2f39484fb173f06dbb07707a66465ac791e56aa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yhay81/sqrail/releases/download/v0.2.0/sqrail-v0.2.0-linux-arm64.tar.gz"
      sha256 "8fb2ffb963470ff8f744faca1a46b4a9f5e68cf615ee60691e4a98f73814a63c"
    end

    on_intel do
      url "https://github.com/yhay81/sqrail/releases/download/v0.2.0/sqrail-v0.2.0-linux-x86_64.tar.gz"
      sha256 "d7bd88814075726ca48a0b168e3aeb24b0a5fdf774303fe033415aecda2d5708"
    end
  end

  def install
    bin.install "bin/sqrail"
    doc.install Dir["share/doc/sqrail/*"]
  end

  test do
    assert_match "sqrail #{version}", shell_output("#{bin}/sqrail --version")
    assert_equal "{\"answer\":42}\n", shell_output("#{bin}/sqrail run 'SELECT 42 AS answer'")
  end
end
