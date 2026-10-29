class Sqrail < Formula
  desc "Bounded SQL-on-files CLI for coding agents"
  homepage "https://sqrail.yhay81.com"
  url "https://github.com/yhay81/sqrail/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c6a0d55c35c9ccae2ffbbb5bded1e580593172dd21e47f856aab8e1519b95904"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "duckdb"

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
           "-DSQRAIL_DUCKDB_PROVIDER=SYSTEM",
           "-DSQRAIL_BUILD_TESTS=OFF",
           "-DCMAKE_PREFIX_PATH=#{formula_opt_prefix("duckdb")}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    version_output = shell_output("#{bin}/sqrail --version")
    assert_match "sqrail #{version}", version_output
    assert_match "DuckDB v#{Formula["duckdb"].version}", version_output
    assert_equal "{\"answer\":42}\n", shell_output("#{bin}/sqrail run 'SELECT 42 AS answer'")
    assert_path_exists pkgshare/"skills/sqrail/SKILL.md"
    assert_path_exists pkgshare/"plugin.json"

    (testpath/"input.csv").write <<~CSV
      value
      2
      3
    CSV
    assert_equal "{\"total\":5}\n",
                 shell_output("#{bin}/sqrail run -t data=input.csv 'SELECT sum(value) AS total FROM data'")
  end
end
