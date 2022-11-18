require "benchmark"
require "benchmark/ips"
require "pry"
require_relative './example'
require_relative './example_with_marshal'

class GCSuite
  def warming(*)
    run_gc
  end

  def running(*)
    run_gc
  end

  private

  def run_gc
    GC.enable
    GC.start
    GC.disable
  end
end

suite = GCSuite.new

Benchmark.ips do |x|
  x.report('Hash way') do
    e = Example.new
    1_000_000.times{|t| e.sum(t, t + 1) }
  end
  
  x.report('Marshal way') do
    e = ExampleWithMarshal.new
    1_000_000.times{|t| 
      e.sum(t, t + 1) 
    }
  end
end

# Warming up --------------------------------------
            # Hash way     1.000  i/100ms
         # Marshal way     1.000  i/100ms
# Calculating -------------------------------------
            # Hash way      0.712  (± 0.0%) i/s -      4.000  in   5.623782s
         # Marshal way      0.281  (± 0.0%) i/s -      2.000  in   7.249352s
