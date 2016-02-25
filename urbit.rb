class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  head "https://github.com/urbit/urbit.git"

  depends_on "gmp"
  depends_on "libsigsegv"
  depends_on "openssl"

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build

  def install
    system "mkdir urb"
    system "curl -o urb/urbit.pill http://bootstrap.urbit.org/latest.pill"
    system "make", "BIN=#{bin}", "LIB=#{share}"
    share.install "urb/urbit.pill"
    share.install Dir["urb/zod/*"]
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/urbit") do |_, o, e, ps|
      assert_equal 1, ps.value.exitstatus unless ps.nil?
      assert_equal nil, o.gets(nil)
      assert_match /urbit: usage/, e.gets(nil)
    end
  end
end
