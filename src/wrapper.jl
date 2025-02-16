const callbacks = [:tickPrice,
                   :tickSize,
                   :tickOptionComputation,
                   :tickGeneric,
                   :tickString,
                   :tickEFP,
                   :orderStatus,
                   :openOrder,
                   :openOrderEnd,
#                  :winError,
#                  :connectionClosed,
                   :updateAccountValue,
                   :updatePortfolio,
                   :updateAccountTime,
                   :accountDownloadEnd,
                   :nextValidId,
                   :contractDetails,
                   :bondContractDetails,
                   :contractDetailsEnd,
                   :execDetails,
                   :execDetailsEnd,
                   :error,
                   :updateMktDepth,
                   :updateMktDepthL2,
                   :updateNewsBulletin,
                   :managedAccounts,
                   :receiveFA,
                   :historicalData,
                   :scannerParameters,
                   :scannerData,
                   :realtimeBar,
                   :currentTime,
                   :fundamentalData,
                   :deltaNeutralValidation,
                   :tickSnapshotEnd,
                   :marketDataType,
                   :commissionReport,
                   :position,
                   :positionEnd,
                   :accountSummary,
                   :accountSummaryEnd,
                   :verifyMessageAPI,
                   :verifyCompleted,
                   :displayGroupList,
                   :displayGroupUpdated,
                   :verifyAndAuthMessageAPI,
                   :verifyAndAuthCompleted,
#                  :connectAck,
                   :positionMulti,
                   :positionMultiEnd,
                   :accountUpdateMulti,
                   :accountUpdateMultiEnd,
                   :securityDefinitionOptionalParameter,
                   :securityDefinitionOptionalParameterEnd,
                   :softDollarTiers,
                   :familyCodes,
                   :symbolSamples,
                   :mktDepthExchanges,
                   :tickNews,
                   :smartComponents,
                   :tickReqParams,
                   :newsProviders,
                   :newsArticle,
                   :historicalNews,
                   :historicalNewsEnd,
                   :headTimestamp,
                   :histogramData,
                   :historicalDataUpdate,
                   :rerouteMktDataReq,
                   :rerouteMktDepthReq,
                   :marketRule,
                   :pnl,
                   :pnlSingle,
                   :historicalTicks,
                   :historicalTicksBidAsk,
                   :historicalTicksLast,
                   :tickByTickAllLast,
                   :tickByTickBidAsk,
                   :tickByTickMidPoint,
                   :orderBound,
                   :completedOrder,
                   :completedOrdersEnd,
                   :replaceFAEnd,
                   :wshMetaData,
                   :wshEventData,
                   :historicalSchedule,
                   :userInfo,
                   :historicalDataEnd,
                   :currentTimeInMillis]

abstract type AbstractIBCallbackWrapper end

function forward(w::AbstractIBCallbackWrapper) end

struct Wrapper <: AbstractIBCallbackWrapper

  clientObject::Any

  cb::Dict{Symbol,Function}

  function Wrapper(clientObject; kw...)

    cb = Dict{Symbol,Function}(kw)

    x = setdiff(keys(cb), callbacks)

    isempty(x) || error("unknown callback $x")

    new(clientObject, cb)
  end
end

Wrapper(; kw...) = Wrapper(nothing; kw...)

function forward(w::Wrapper, s::Symbol, data...)
  co = getfield(w, :clientObject)
  isnothing(co) && return getproperty(w, s)(data...)
  getproperty(w, s)(co, data...)
end

Base.getproperty(w::Wrapper, name::Symbol) =
  get(getfield(w, :cb), name) do

    if name ∈ callbacks
      @info "undefined callback" name
    else
      @error "unknown callback" name
    end

    # Noop
    (_...) -> nothing
  end


Base.propertynames(w::Wrapper) = getfield(w, :cb) |> keys |> collect


function Base.setproperty!(w::Wrapper, name::Symbol, f)

  name ∈ callbacks || error("unknown callback $name")

  getfield(w, :cb)[name] = f
end

include("simple_wrap.jl")
