class Sqrail < Formula
  desc "Minimal SQL-on-files CLI for coding agents"
  homepage "https://yhay81.github.io/sqrail/"
  version "0.2.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yhay81/sqrail/releases/download/v0.2.1/sqrail-v0.2.1-macos-arm64.tar.gz"
      sha256 "04e8789ad3f908b0dc6521e75f2aa3c2cac903f2b6c1e2238377dec9cf112169"
    end

    on_intel do
      url "https://github.com/yhay81/sqrail/releases/download/v0.2.1/sqrail-v0.2.1-macos-x86_64.tar.gz"
      sha256 "d651ea2635ac91bc95bbd0327af75f4f8d5ecf8c1adbe5fd8c9f075a9c6c4760"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yhay81/sqrail/releases/download/v0.2.1/sqrail-v0.2.1-linux-arm64.tar.gz"
      sha256 "3d79ae318e4c2375a1d3f02861e7b4465dac856b18fe1a6ee5e19fb1e7e0c899"
    end

    on_intel do
      url "https://github.com/yhay81/sqrail/releases/download/v0.2.1/sqrail-v0.2.1-linux-x86_64.tar.gz"
      sha256 "a8415bf4e894e25551cde2e01173a8d2f4c7b93c8dbcd3ae2327c8959bd33815"
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
