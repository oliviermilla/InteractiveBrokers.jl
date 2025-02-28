using Sockets

#wrap = InteractiveBrokers.Wrapper();

wrap = InteractiveBrokers.Wrapper(
         # Customized methods go here
         error= (id, errorTime, errorCode, errorString, advancedOrderRejectJson) ->
                  println("Error: $(something(id, "NA")) $errorTime $errorCode $errorString $advancedOrderRejectJson"),

         nextValidId= (orderId) -> println("Next OrderId: $orderId"),

         managedAccounts= (accountsList) -> println("Managed Accounts: $accountsList")

         # more method overrides can go here...
       );

# Connect to the server with clientId = 1
ib = InteractiveBrokers.connect(port=4002, clientId=1);

InteractiveBrokers.reqMarketDataType(ib, InteractiveBrokers.DELAYED)

# Start a background Task to process the server responses
InteractiveBrokers.start_reader(ib, wrap);

# Define contract
contract = InteractiveBrokers.Contract(symbol="GOOG",
                        secType="STK",
                        exchange="SMART",
                        currency="USD");

# Define order
order = InteractiveBrokers.Order();
order.action        = "BUY"
order.totalQuantity = 10
order.orderType     = "LMT"
order.lmtPrice      = 100

orderId = 1    # Should match whatever is returned by the server

# Send order
InteractiveBrokers.placeOrder(ib, orderId, contract, order)

# Wait for the server to send the first replies.
sleep(100);

# Disconnect
InteractiveBrokers.disconnect(ib)