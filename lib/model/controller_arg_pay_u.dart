// To parse this JSON data, do
//
//     final payUModelService = PayUModelServiceFromJson(jsonString);

import 'dart:convert';

PayUModelService payUModelServiceFromJson(String str) =>
    PayUModelService.fromJson(json.decode(str));

String payUModelServiceToJson(PayUModelService data) =>
    json.encode(data.toJson());

class PayUModelService {
  PayUModelService({
    required this.language,
    required this.command,
    required this.merchant,
    required this.transaction,
    required this.test,
  });

  String language;
  String command;
  Merchant merchant;
  Transaction transaction;
  bool test;

  factory PayUModelService.fromJson(Map<String, dynamic> json) =>
      PayUModelService(
        language: json["language"],
        command: json["command"],
        merchant: Merchant.fromJson(json["merchant"]),
        transaction: Transaction.fromJson(json["transaction"]),
        test: json["test"],
      );

  Map<String, dynamic> toJson() => {
        "language": language,
        "command": command,
        "merchant": merchant.toJson(),
        "transaction": transaction.toJson(),
        "test": test,
      };
}

class Merchant {
  Merchant({
    required this.apiKey,
    required this.apiLogin,
  });

  String apiKey;
  String apiLogin;

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
        apiKey: json["apiKey"],
        apiLogin: json["apiLogin"],
      );

  Map<String, dynamic> toJson() => {
        "apiKey": apiKey,
        "apiLogin": apiLogin,
      };
}

class Transaction {
  Transaction({
    required this.order,
    required this.payer,
    required this.creditCard,
    required this.extraParameters,
    required this.type,
    required this.paymentMethod,
    required this.paymentCountry,
    required this.deviceSessionId,
    required this.ipAddress,
    required this.cookie,
    required this.userAgent,
    required this.threeDomainSecure,
  });

  Order order;
  Payer payer;
  CreditCard creditCard;
  ExtraParameter extraParameters;
  String type;
  String paymentMethod;
  String paymentCountry;
  String deviceSessionId;
  String ipAddress;
  String cookie;
  String userAgent;
  ThreeDomainSecure threeDomainSecure;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        order: Order.fromJson(json["order"]),
        payer: Payer.fromJson(json["payer"]),
        creditCard: CreditCard.fromJson(json["creditCard"]),
        extraParameters: ExtraParameter.fromJson(json["extraParameters"]),
        type: json["type"],
        paymentMethod: json["paymentMethod"],
        paymentCountry: json["paymentCountry"],
        deviceSessionId: json["deviceSessionId"],
        ipAddress: json["ipAddress"],
        cookie: json["cookie"],
        userAgent: json["userAgent"],
        threeDomainSecure:
            ThreeDomainSecure.fromJson(json["threeDomainSecure"]),
      );

  Map<String, dynamic> toJson() => {
        "order": order.toJson(),
        "payer": payer.toJson(),
        "creditCard": creditCard.toJson(),
        "extraParameters": extraParameters.toJson(),
        "type": type,
        "paymentMethod": paymentMethod,
        "paymentCountry": paymentCountry,
        "deviceSessionId": deviceSessionId,
        "ipAddress": ipAddress,
        "cookie": cookie,
        "userAgent": userAgent,
        "threeDomainSecure": threeDomainSecure.toJson(),
      };
}

class CreditCard {
  CreditCard({
    required this.number,
    required this.securityCode,
    required this.expirationDate,
    required this.name,
  });

  String number;
  String securityCode;
  String expirationDate;
  String name;

  factory CreditCard.fromJson(Map<String, dynamic> json) => CreditCard(
        number: json["number"],
        securityCode: json["securityCode"],
        expirationDate: json["expirationDate"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "securityCode": securityCode,
        "expirationDate": expirationDate,
        "name": name,
      };
}

class ExtraParameter {
  ExtraParameter({
    required this.installmentsNumber,
  });

  int installmentsNumber;

  factory ExtraParameter.fromJson(Map<String, dynamic> json) => ExtraParameter(
        installmentsNumber: json["INSTALLMENTS_NUMBER"],
      );

  Map<String, dynamic> toJson() => {
        "INSTALLMENTS_NUMBER": installmentsNumber,
      };
}

class Order {
  Order({
    required this.accountId,
    required this.referenceCode,
    required this.description,
    required this.language,
    required this.signature,
    required this.notifyUrl,
    required this.additionalValues,
    required this.buyer,
    required this.shippingAddress,
  });

  String accountId;
  String referenceCode;
  String description;
  String language;
  String signature;
  String notifyUrl;
  AdditionalValues additionalValues;
  Buyer buyer;
  IngAddress shippingAddress;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        accountId: json["accountId"],
        referenceCode: json["referenceCode"],
        description: json["description"],
        language: json["language"],
        signature: json["signature"],
        notifyUrl: json["notifyUrl"],
        additionalValues: AdditionalValues.fromJson(json["additionalValues"]),
        buyer: Buyer.fromJson(json["buyer"]),
        shippingAddress: IngAddress.fromJson(json["shippingAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "accountId": accountId,
        "referenceCode": referenceCode,
        "description": description,
        "language": language,
        "signature": signature,
        "notifyUrl": notifyUrl,
        "additionalValues": additionalValues.toJson(),
        "buyer": buyer.toJson(),
        "shippingAddress": shippingAddress.toJson(),
      };
}

class AdditionalValues {
  AdditionalValues({
    required this.txValue,
    required this.txTax,
    required this.txTaxReturnBase,
  });

  Tx txValue;
  Tx txTax;
  Tx txTaxReturnBase;

  factory AdditionalValues.fromJson(Map<String, dynamic> json) =>
      AdditionalValues(
        txValue: Tx.fromJson(json["TX_VALUE"]),
        txTax: Tx.fromJson(json["TX_TAX"]),
        txTaxReturnBase: Tx.fromJson(json["TX_TAX_RETURN_BASE"]),
      );

  Map<String, dynamic> toJson() => {
        "TX_VALUE": txValue.toJson(),
        "TX_TAX": txTax.toJson(),
        "TX_TAX_RETURN_BASE": txTaxReturnBase.toJson(),
      };
}

class Tx {
  Tx({
    required this.value,
    required this.currency,
  });

  int value;
  String currency;

  factory Tx.fromJson(Map<String, dynamic> json) => Tx(
        value: json["value"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "currency": currency,
      };
}

class Buyer {
  Buyer({
    required this.merchantBuyerId,
    required this.fullName,
    required this.emailAddress,
    required this.contactPhone,
    required this.dniNumber,
    required this.shippingAddress,
  });

  String merchantBuyerId;
  String fullName;
  String emailAddress;
  String contactPhone;
  String dniNumber;
  IngAddress shippingAddress;

  factory Buyer.fromJson(Map<String, dynamic> json) => Buyer(
        merchantBuyerId: json["merchantBuyerId"],
        fullName: json["fullName"],
        emailAddress: json["emailAddress"],
        contactPhone: json["contactPhone"],
        dniNumber: json["dniNumber"],
        shippingAddress: IngAddress.fromJson(json["shippingAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "merchantBuyerId": merchantBuyerId,
        "fullName": fullName,
        "emailAddress": emailAddress,
        "contactPhone": contactPhone,
        "dniNumber": dniNumber,
        "shippingAddress": shippingAddress.toJson(),
      };
}

class IngAddress {
  IngAddress({
    required this.street1,
    required this.street2,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.phone,
  });

  String street1;
  String street2;
  String city;
  String state;
  String country;
  String postalCode;
  String phone;

  factory IngAddress.fromJson(Map<String, dynamic> json) => IngAddress(
        street1: json["street1"],
        street2: json["street2"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postalCode: json["postalCode"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "street1": street1,
        "street2": street2,
        "city": city,
        "state": state,
        "country": country,
        "postalCode": postalCode,
        "phone": phone,
      };
}

class Payer {
  Payer({
    required this.merchantPayerId,
    required this.fullName,
    required this.emailAddress,
    required this.contactPhone,
    required this.dniNumber,
    required this.billingAddress,
  });

  String merchantPayerId;
  String fullName;
  String emailAddress;
  String contactPhone;
  String dniNumber;
  IngAddress billingAddress;

  factory Payer.fromJson(Map<String, dynamic> json) => Payer(
        merchantPayerId: json["merchantPayerId"],
        fullName: json["fullName"],
        emailAddress: json["emailAddress"],
        contactPhone: json["contactPhone"],
        dniNumber: json["dniNumber"],
        billingAddress: IngAddress.fromJson(json["billingAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "merchantPayerId": merchantPayerId,
        "fullName": fullName,
        "emailAddress": emailAddress,
        "contactPhone": contactPhone,
        "dniNumber": dniNumber,
        "billingAddress": billingAddress.toJson(),
      };
}

class ThreeDomainSecure {
  ThreeDomainSecure({
    required this.embedded,
    required this.eci,
    required this.cavv,
    required this.xid,
    required this.directoryServerTransactionId,
  });

  bool embedded;
  String eci;
  String cavv;
  String xid;
  String directoryServerTransactionId;

  factory ThreeDomainSecure.fromJson(Map<String, dynamic> json) =>
      ThreeDomainSecure(
        embedded: json["embedded"],
        eci: json["eci"],
        cavv: json["cavv"],
        xid: json["xid"],
        directoryServerTransactionId: json["directoryServerTransactionId"],
      );

  Map<String, dynamic> toJson() => {
        "embedded": embedded,
        "eci": eci,
        "cavv": cavv,
        "xid": xid,
        "directoryServerTransactionId": directoryServerTransactionId,
      };
}
