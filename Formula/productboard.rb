class Productboard < Formula
  desc "Read-only Jira Cloud workspace for your terminal"
  homepage "https://github.com/murabcd/productboard"
  url "https://github.com/murabcd/productboard/releases/download/v0.1.1/productboard-0.1.1-revision2.tar.gz"
  sha256 "f46f36f5f7305d1f74c25021c0fae218acb827d593f03eec3c59851f73af6195"
  revision 2

  depends_on macos: :ventura
  depends_on "node@24"

  resource "bun" do
    on_arm do
      url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.14/bun-darwin-aarch64.zip"
      sha256 "d8b96221828ad6f97ac7ac0ab7e95872341af763001e8803e8267652c2652620"
    end

    on_intel do
      url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.14/bun-darwin-x64-baseline.zip"
      sha256 "3e35ad6f53971a9834bf9e6786e2adf72b5f1921cc9a9c5fde073d2972944076"
    end
  end

  def install
    resource("bun").stage { (libexec/"runtime").install "bun" }
    bun = libexec/"runtime/bun"
    system bun, "install", "--frozen-lockfile", "--production"

    libexec.install "agent", "bin", "node_modules", "package.json", "src", "tsconfig.json"
    (bin/"productboard").write_env_script libexec/"bin/productboard",
                                         BUN: bun, PATH: "#{formula_opt_bin("node@24")}:$PATH"
  end

  test do
    assert_match "Usage: productboard", shell_output("#{bin}/productboard --help")
    assert_equal "productboard v#{version}", shell_output("#{bin}/productboard --version").strip
  end
end
