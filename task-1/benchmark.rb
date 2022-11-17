require "benchmark"
require "benchmark/ips"

class GCSuite
  def warming(*)
    run_gc
  end

  def running(*)
    run_gc
  end

  def warmup_stats(*)
  end

  def add_report(*)
  end

  private

  def run_gc
    GC.enable
    GC.start
    GC.disable
  end
end

suite = GCSuite.new

value = rand 5000..10000

Benchmark.ips do |x|
  x.report('Hash way') { 
    hash = {}

    1000000.times do
      hash[args.hash] = value
    end
  }

  x.report('Marshal way') { 
    hash = {}

    1000000.times do
      key = Marshal.dump(value)
      hash.merge!({key => value})
    end
  }
end
# Warming up --------------------------------------
            # Hash way     1.000  i/100ms
         # Marshal way     1.000  i/100ms
# Calculating -------------------------------------
            # Hash way      6.409  (± 0.0%) i/s -     33.000  in   5.151042s
         # Marshal way      0.775  (± 0.0%) i/s -      4.000  in   5.159335s
