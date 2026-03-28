@testset "Utils" begin

  @test InteractiveBrokers.tickname(0) == "BID_SIZE"

  @test InteractiveBrokers.tickname(90) == "DELAYED_HALTED"

  @test InteractiveBrokers.tickname(102) == "FINAL_IPO_LAST"

# InteractiveBrokers does not use that logic. Instead it will throw an error. 
#  @test (@test_logs (:error, "tickname(): unknown ticktype") InteractiveBrokers.tickname(-1)) == "UNKNOWN"

  @test InteractiveBrokers.funddist("Y") == "Income Fund"
  @test InteractiveBrokers.fundtype("003") == "Multi-asset"
  @test InteractiveBrokers.funddist("") == InteractiveBrokers.fundtype("") == "None"

end
