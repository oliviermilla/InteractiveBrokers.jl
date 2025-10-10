@testset "Client" begin

  @test sizeof(InteractiveBrokers.Client.HEADTYPE) == 4
  @test sizeof(InteractiveBrokers.Client.RAWIDTYPE) == 4

  @test InteractiveBrokers.Client.MAX_LEN < typemax(InteractiveBrokers.Client.HEADTYPE)

 

  # buffer
  buf = InteractiveBrokers.Client.buffer(true)
  @test ismarked(buf)
  @test reset(buf) == 8
  @test String(take!(buf)) == InteractiveBrokers.Client.API_SIGN * "\0\0\0\0"

  # write_one
  buf = InteractiveBrokers.Client.buffer(true)
  write(buf, "ABC")
  bo = IOBuffer()
  InteractiveBrokers.Client.write_one(bo, buf)

  @test buf.size == 0
  @test String(take!(bo)) == InteractiveBrokers.Client.API_SIGN * "\0\0\0\x03ABC"

  # Round trip
  buf = InteractiveBrokers.Client.buffer(false)
  write(buf, hton(InteractiveBrokers.Client.RAWIDTYPE(123)))
  write(buf, "ABC")

  bo = IOBuffer()
  InteractiveBrokers.Client.write_one(bo, buf)

  seekstart(bo) # Rewind
  id, m = InteractiveBrokers.Client.read_one(bo)

  @test id == 123
  @test String(m) == "ABC"
  @test eof(bo)
  @test bo.size == 11

end
