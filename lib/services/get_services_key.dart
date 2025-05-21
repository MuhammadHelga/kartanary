import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/firebase.messaging',
      // 'https://www.googleapis.com/auth/cloud-platform',
      // 'https://www.googleapis.com/auth/cloud-platform.googleapis.com/notifications' // Add this scope
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "lifesync-capstone",
        "private_key_id": "5b2a404cbc91ad9a88f834905cc0ebbbf47d5fe8",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDI49yFgXBwkUb0\nx2tkz/JKPx6iUmh3QYdOcrH3mWn3hApSsYgFSf+n6hd2+SdddlmPTU1XWclXL325\nmK4iE96HcTAm9uW0y+U5kQzSAsPX4OOxr8ru4AziepHKPb2YNmTSkpvAvURRM0WY\nmHlJOWxNs/aNswQtG4So/IXREJqa1yanj/UcTrT3e17rUz8cbtKVve8oZwquiZGS\nuurNIa8PW+5IEsL5jG4O28xQY/L/7OFk2RMRcBmjdIOQPhgLTJwqz1rzrFiYk91g\nu6ei+HoqysQni30fPv7R4709a0vhilChXNViikyTpWAMMpIMeQANPTKmOc4j5//2\nhUWRgVZpAgMBAAECggEAElggXH6X5meVu6d0KpYEkXwXD4qH6I/uy56UmsADGauQ\nh8GXYqhBtLMfJmmVCydSAVB1Rgs4ZAI9sFN9XzZCRUr0MzKrgil2Sp3wtkKzYIS0\nNhcP6GVEN/AqXPXrWLlq1oG1wFFoKiQM8GTH+oRIXAYZdxIISRgwsn+wtokWHRpr\n2v506NBQlUAtvZ8Gzf3XHw1sRYTfFNck5OvoJVYxU+d1WPtM6RLaQT83fu8zbgZE\nSXWJTY/Jk1b6JMgawo/RZ4BFo+F01AijQEAikC2JLZsdavmqRYtPxl6Px0cIWo91\ntumlE+9P2zOwY1y/T1/MPHJp0ybteDnbDLzwkTC+SQKBgQD6ItZppKy0itVTkiIo\nr0Tf1N3yldA+3AjEbHZ6sG39PdoQpGmoYSzeQd0rwhWp97Hat2bkunRDdjEIvVTE\nCk9q46HsmqqG8mH51e5CtQaYa7LMbEw0chTTPK0DARobE7vhiwjqydCekPoGyGVL\nQsmtS2pck/xkX6tE26BK9zPknQKBgQDNmXrQ8oArWTdxvn+AV4im73qRyClNv7bc\nltgPIDdw9sv3akTGTuRp3+HI89Q59waW3qW3X0zO1cgyWSgv+nZRSHmBE9qKYgJv\n0DaR5XMIQuCn4kyZMgxnss0atHx/NeQnKbDDwGJsWMyapcb1omOwQe9QbrwXsSUK\nuxLzifhBPQKBgF1Iyr/BSytVr3MoR5b2rm/vWgqTNoOK2bYvYQwmag6Ml5unRUQn\nYW1OEOa1zhCCMJEJ3tSkeKGEHYtN2KP32GBbnlK356rGECX1U5MLIfeMCrVUGiNg\n/EU/FqLNMWgxttrJWDz/oM7R8HzBFY24za/UNUlrYzAnwZ6/bYsnn/G9AoGBAJyR\nqMm+IoTgaCyimY4vGs2lyX2DJJEk0iiiZt799bp8907vCnjKU3+dEuBpbtDFoar6\n2tAOLvvEKbTN2KDQ55F207DMYbzIbnqf4S6xwSwlYdf3qcVwK6o8q50OnVByxdBd\nG1O3CjzgUs/iNuWQSMJNM+XYrjyMllzZodD83KUxAoGBAO/fkX44pl2s7jiJ1E8b\nsLwIESbYsb+JgL76yJOFt17YhDzs4/9HXwyM+FGeSil/H5V77+lux21/WL54kJCh\nfmdCWcYAUJa2PW4vNln3AyoJzxBiVg0ze9VacfbJNVrfiWDLkOpEnxhGmj6a035k\nIAu/BJi10gI7YXv7AheAIXaJ\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@lifesync-capstone.iam.gserviceaccount.com",
        "client_id": "103130264815974347206",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40lifesync-capstone.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      }),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
