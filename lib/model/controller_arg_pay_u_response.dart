// To parse this JSON data, do
//
//     final ResponsePayModel = ResponsePayModelFromJson(jsonString);

import 'dart:convert';

ResponsePayModel responsePayModelFromJson(String str) =>
    ResponsePayModel.fromJson(json.decode(str));

String responsePayModelToJson(ResponsePayModel data) =>
    json.encode(data.toJson());

class ResponsePayModel {
  ResponsePayModel({
    required this.code,
    this.error,
    required this.transactionResponse,
  });

  String code;
  dynamic error;
  TransactionResponse? transactionResponse;

  factory ResponsePayModel.fromJson(Map<String, dynamic> json) =>
      ResponsePayModel(
        code: json["code"] == null ? 'null error' : json["code"],
        error: json["error"] == null ? 'null error' : json["error"],
        transactionResponse: json["transactionResponse"] == null
            ? json["transactionResponse"]
            : TransactionResponse.fromJson(json["transactionResponse"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
        "transactionResponse": transactionResponse?.toJson(),
      };
}

class TransactionResponse {
  TransactionResponse({
    required this.orderId,
    required this.transactionId,
    required this.state,
    required this.paymentNetworkResponseCode,
    required this.paymentNetworkResponseErrorMessage,
    required this.trazabilityCode,
    required this.authorizationCode,
    required this.pendingReason,
    required this.responseCode,
    required this.errorCode,
    required this.responseMessage,
    required this.transactionDate,
    required this.transactionTime,
    required this.operationDate,
    required this.referenceQuestionnaire,
    required this.extraParameters,
    required this.additionalInfo,
  });

  int orderId;
  String transactionId;
  String state;
  String paymentNetworkResponseCode;
  dynamic paymentNetworkResponseErrorMessage;
  String trazabilityCode;
  dynamic authorizationCode;
  dynamic pendingReason;
  String responseCode;
  dynamic errorCode;
  dynamic responseMessage;
  dynamic transactionDate;
  dynamic transactionTime;
  int operationDate;
  dynamic referenceQuestionnaire;
  ExtraParameters extraParameters;
  AdditionalInfo additionalInfo;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      TransactionResponse(
        orderId: json["orderId"] == null ? 0 : json["orderId"],
        transactionId: json["transactionId"] == null
            ? 'null error'
            : json["transactionId"],
        state: json["state"] == null ? 'null error' : json["state"],
        paymentNetworkResponseCode: json["paymentNetworkResponseCode"] == null
            ? 'null error'
            : json["paymentNetworkResponseCode"],
        paymentNetworkResponseErrorMessage:
            json["paymentNetworkResponseErrorMessage"] == null
                ? 'null error'
                : json["paymentNetworkResponseErrorMessage"],
        trazabilityCode: json["trazabilityCode"] == null
            ? 'null error'
            : json["trazabilityCode"],
        authorizationCode: json["authorizationCode"] == null
            ? 'null error'
            : json["authorizationCode"],
        pendingReason: json["pendingReason"] == null
            ? 'null error'
            : json["pendingReason"],
        responseCode:
            json["responseCode"] == null ? 'null error' : json["responseCode"],
        errorCode: json["errorCode"] == null ? 'null error' : json["errorCode"],
        responseMessage: json["responseMessage"] == null
            ? 'null error'
            : json["responseMessage"],
        transactionDate: json["transactionDate"] == null
            ? 'null error'
            : json["transactionDate"],
        transactionTime: json["transactionTime"] == null
            ? 'null error'
            : json["transactionTime"],
        operationDate:
            json["operationDate"] == null ? 0 : json["operationDate"],
        referenceQuestionnaire: json["referenceQuestionnaire"] == null
            ? 'null error'
            : json["referenceQuestionnaire"],
        extraParameters: json["extraParameters"] == null
            ? ExtraParameters(bankReferencedCode: 'error')
            : ExtraParameters.fromJson(json["extraParameters"]),
        additionalInfo: json["additionalInfo"] == null
            ? AdditionalInfo(
                cardType: '',
                paymentNetwork: '',
                rejectionType: '',
                responseNetworkMessage: '',
                transactionType: '',
                travelAgencyAuthorizationCode: '')
            : AdditionalInfo.fromJson(json["additionalInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "transactionId": transactionId,
        "state": state,
        "paymentNetworkResponseCode": paymentNetworkResponseCode,
        "paymentNetworkResponseErrorMessage":
            paymentNetworkResponseErrorMessage,
        "trazabilityCode": trazabilityCode,
        "authorizationCode": authorizationCode,
        "pendingReason": pendingReason,
        "responseCode": responseCode,
        "errorCode": errorCode,
        "responseMessage": responseMessage,
        "transactionDate": transactionDate,
        "transactionTime": transactionTime,
        "operationDate": operationDate,
        "referenceQuestionnaire": referenceQuestionnaire,
        "extraParameters": extraParameters.toJson(),
        "additionalInfo": additionalInfo.toJson(),
      };
}

class AdditionalInfo {
  AdditionalInfo({
    required this.paymentNetwork,
    required this.rejectionType,
    required this.responseNetworkMessage,
    required this.travelAgencyAuthorizationCode,
    required this.cardType,
    required this.transactionType,
  });

  String paymentNetwork;
  String rejectionType;
  dynamic responseNetworkMessage;
  dynamic travelAgencyAuthorizationCode;
  String cardType;
  String transactionType;

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
        paymentNetwork: json["paymentNetwork"] == null
            ? 'null error'
            : json["paymentNetwork"],
        rejectionType: json["rejectionType"] == null
            ? 'null error'
            : json["rejectionType"],
        responseNetworkMessage: json["responseNetworkMessage"] == null
            ? 'null error'
            : json["responseNetworkMessage"],
        travelAgencyAuthorizationCode:
            json["travelAgencyAuthorizationCode"] == null
                ? 'null error'
                : json["travelAgencyAuthorizationCode"],
        cardType: json["cardType"] == null ? 'null error' : json["cardType"],
        transactionType: json["transactionType"] == null
            ? 'null error'
            : json["transactionType"],
      );

  Map<String, dynamic> toJson() => {
        "paymentNetwork": paymentNetwork,
        "rejectionType": rejectionType,
        "responseNetworkMessage": responseNetworkMessage,
        "travelAgencyAuthorizationCode": travelAgencyAuthorizationCode,
        "cardType": cardType,
        "transactionType": transactionType,
      };
}

class ExtraParameters {
  ExtraParameters({
    required this.bankReferencedCode,
  });

  String bankReferencedCode;

  factory ExtraParameters.fromJson(Map<String, dynamic> json) =>
      ExtraParameters(
        bankReferencedCode: json["BANK_REFERENCED_CODE"] == null
            ? 'null error'
            : json["BANK_REFERENCED_CODE"],
      );

  Map<String, dynamic> toJson() => {
        "BANK_REFERENCED_CODE": bankReferencedCode,
      };
}
