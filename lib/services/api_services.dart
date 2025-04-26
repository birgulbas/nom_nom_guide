import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nom_nom_guide/models/place.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nom_nom_guide/models/review.dart';

class ApiServices {
  // Base url apinin
 static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api'; // Android
    } else {
      return 'http://localhost:8000/api'; // IOS ve diğer platformlar
  

    }
  }

  // Kategorileri apiden çekme fonksiyonu
  Future<List<Map<String, String>>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories/'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Kategori GET: ${response.statusCode}');

    if (response.statusCode == 200) {
      try {
        final decodedBody = utf8.decode(response.bodyBytes); // Türkçe karakter desteği
        List<dynamic> data = json.decode(decodedBody);
        return data.map<Map<String, String>>((category) {
          return {
            'label': category['label'].toString(),
            'key': category['key'].toString(),
          };
        }).toList();
      } catch (e) {
        print('Kategori verisi parse hatası: $e');
        throw Exception('Kategori verisi işlenemedi.');
      }
    } else {
      print('Kategori yükleme başarısız: ${response.statusCode}');
      throw Exception('Categories could not be loaded.');
    }
  }

  // Mekanları kategori ve filtrelere göre çekme fonksiyonu
  Future<List<Place>> getPlaces({
    String? category,
    String? searchQuery,
    String? price,
    double? minRating,
    bool? hasWifi,
  }) async {
    String url = '$baseUrl/places/';
    Map<String, String> queryParams = {};

    // Filtreleme parametreleri
    if (category != null) queryParams['category'] = category;
    if (searchQuery != null) queryParams['search'] = searchQuery;
    if (price != null) queryParams['price_range'] = price;
    if (minRating != null) queryParams['min_rating'] = minRating.toString();
    if (hasWifi != null) queryParams['wifi'] = hasWifi.toString();

    // Eğer herhangi bir filtre varsa URL'ye ekliyoruz
    if (queryParams.isNotEmpty) {
      url += '?${Uri(queryParameters: queryParams).query}';
    }

    final token = await getToken();
    print('Kullanılan Token: $token');
    print('İstek URL: $url');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes); // Türkçe karakter
        final decoded = json.decode(decodedBody);
        final data = decoded is List ? decoded : decoded['results'];
        return data.map<Place>((json) => Place.fromJson(json)).toList();
      } else {
        throw Exception('Mekanlar yüklenemedi (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Veri çekerken hata: $e');
      throw Exception('Veri alınırken hata oluştu: $e');
    }
  }

  // SharedPreferences'tan token'ı alır
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // yorumları apiden çekme fonksiyonu
  Future<List<Review>> getReviews(int placeId) async {
    final token = await getToken();
    String url = '$baseUrl/places/$placeId/reviews/';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes); // Türkçe karakter desteği
        final decoded = json.decode(decodedBody);
        final data = decoded is List ? decoded : decoded['results'];
        return data.map<Review>((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Yorumlar yüklenemedi (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Veri çekerken hata: $e');
      throw Exception('Yorumlar alınırken hata oluştu: $e');
    }
  }

  // favori durumunu kontrol etme
  Future<bool> isFavorite(int placeId) async {
    final token = await getToken();
    String url = '$baseUrl/places/$placeId/favorite/';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes); // Türkçe karakter desteği
        final decoded = json.decode(decodedBody);
        // API'den gelen yanıtla favori durumu döndürülüyor
        return decoded['isFavorite'] ?? false;
      } else {
        throw Exception('Favori durumu alınamadı (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Favori durumu kontrol edilirken hata: $e');
      throw Exception('Favori durumu kontrol edilirken hata oluştu: $e');
    }
  }

  // favori durumu değiştirme fonksiyonu
  Future<void> toggleFavorite(int placeId) async {
    final token = await getToken();
    final url = '$baseUrl/places/$placeId/favorite/';  // URL'yi dinamik yaptık

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Favori durumu güncellenemedi (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Favori durumu güncellenirken hata: $e');
      throw Exception('Favori durumu güncellenirken hata oluştu: $e');
    }
  }

  // yorum ekleme fonksiyonu
  Future<void> addReview(int placeId, String comment, int rating) async {
    final token = await getToken();
    String url = '$baseUrl/places/$placeId/reviews/add/';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    Map<String, dynamic> body = {
      'comment': comment,
      'rating': rating,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        print('Yorum başarıyla eklendi!');
      } else {
        throw Exception('Yorum eklenemedi (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Yorum eklerken hata: $e');
      throw Exception('Yorum eklenirken hata oluştu: $e');
    }
  }
}
