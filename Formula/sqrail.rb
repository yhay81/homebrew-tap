class Sqrail < Formula
  desc "Bounded SQL-on-files CLI for coding agents"
  homepage "https://sqrails.yhay81.com"
  url "https://github.com/yhay81/sqrail/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "36a4dce50a70c207f7b03ea839244caf7857fd071a2874109d8d3a54efd34bed"
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
