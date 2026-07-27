class Sqrail < Formula
  desc "Minimal SQL-on-files CLI for coding agents"
  homepage "https://yhay81.github.io/sqrail/"
  url "https://github.com/yhay81/sqrail/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "417c1ab2d5ba7562ab7b02e1e743dec63481629ed4f39fbff6830382d329e805"
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

    (testpath/"input.csv").write <<~CSV
      value
      2
      3
    CSV
    assert_equal "{\"total\":5}\n",
                 shell_output("#{bin}/sqrail run -t data=input.csv 'SELECT sum(value) AS total FROM data'")
  end
end
