class Sqrail < Formula
  desc "Minimal SQL-on-files CLI for coding agents"
  homepage "https://yhay81.github.io/sqrail/"
  url "https://github.com/yhay81/sqrail/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "1837c06ec24d331337ea5f20bf3a8f8a229579929e11daabc8f52a44d96a5419"
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
