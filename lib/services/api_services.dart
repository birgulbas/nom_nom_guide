import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nom_nom_guide/models/place.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nom_nom_guide/models/review.dart';

class ApiServices {
  // Base url apinin

 static String get baseUrl {
  return 'https://bitirmeprojesi-1xwg.onrender.com/api';
}

// Tokenı kaydet
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
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
        throw Exception('Category data could not be processed.');
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

    // Eğer herhangi bir filtre varsa urlye ekliyoruz
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
        throw Exception('Locations could not be loaded (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Error while fetching data: $e');
      throw Exception('An error occurred while retrieving data: $e');
    }
  }

  // SharedPreferences'tan token'ı alır
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // yorumları apiden çekme fonksiyonu
static Future<List<Review>> fetchReviews(int placeId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    throw Exception('No token found.');
  }

  final response = await http.get(
    Uri.parse('$baseUrl/reviews/?place_id=$placeId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => Review.fromJson(item)).toList();
  } else {
    throw Exception('Comments could not be loaded.');
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
        throw Exception('Favorite status could not be retrieved (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Error checking favorite status: $e');
      throw Exception('An error occurred while checking the favorite status.: $e');
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
        throw Exception('Favorite status could not be updated (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Error while updating favorite status: $e');
      throw Exception('Favori durumu güncellenirken hata oluştu: $e');
    }
  }

  // yorum ekleme fonksiyonu
  Future<void> addReview(int placeId, String comment, int rating) async {
    final token = await getToken();
    String url = '$baseUrl/places/$placeId/reviews/';

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
         Uri.parse('$baseUrl/places/$placeId/review/'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        print('Review added successfully!!');
      } else {
        throw Exception('Comment could not be added (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Error adding review: $e');
      throw Exception('An error occurred while adding a comment: $e');
    }
  }
// Kayıt ol
  Future<bool> register(String firstName, String lastName, String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Registration error: ${response.body}');
      return false;
    }
  }
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    print('Login response status: ${response.statusCode}');
    print('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('access_token')) {
        String token = data['access_token'];
        await saveToken(token);
        print('Token kaydedildi: $token');
        return true;
      } else {
        print('Access token bulunamadı!');
        return false;
      }
    } else {
      print('Login error: ${response.body}');
      return false;
    }
  }

  // Şifre değiştir
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    final token = await getToken();
    if (token == null) {
      print('No token found!');
      return false;
    }

    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var bodyData = jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
      });

      print('Şifre değiştir request headers: $headers');
      print('Şifre değiştir request body: $bodyData');

      final response = await http.post(
        Uri.parse('$baseUrl/change_password/'),

        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Change password error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Change password request failed: $e');
      return false;
    }
  }
  // Kullanıcının yaptığı yorumları getir
  Future<List<dynamic>> getUserComments(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/comments/?username=$username'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load comments');
    }
  }

  // Kullanıcının yaptığı yıldızlamaları getir
  Future<List<dynamic>> getUserRatings(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/ratings/?username=$username'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load ratings');
    }
  }

  // Kullanıcı bilgilerini getir
  Future<Map<String, dynamic>?> getUserInfo() async {
    final token = await getToken();
    if (token == null) {
      print('Token bulunamadı, kullanıcı bilgisi alınamadı.');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/me/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Kullanıcı bilgisi başarıyla alındı.');
        return json.decode(response.body);
      } else {
        print('Kullanıcı bilgisi alınamadı: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Kullanıcı bilgisi alınırken hata: $e');
      return null;
    }
  }

  Future<bool> updateUserInfo({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
  }) async {
    final token = await getToken();
    if (token == null) {
      print('Token bulunamadı, güncelleme yapılamadı.');
      return false;
    }

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/me/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        print('Kullanıcı bilgileri başarıyla güncellendi.');
        return true;
      } else {
        print('Kullanıcı güncelleme hatası: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Kullanıcı bilgileri güncellenirken hata oluştu: $e');
      return false;
    }
  }




// yorum silme fonk
static Future<bool> deleteReview(int reviewId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final response = await http.delete(
    Uri.parse('$baseUrl/reviews/$reviewId/'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  return response.statusCode == 200;
}

// yorum güncelleme fonksiyonu
static Future<bool> updateReview({
  required int reviewId,
  String? updatedComment,
  int? updatedRating,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    print('Token bulunamadı!');
    return false;
  }

  Map<String, dynamic> updatedData = {};
  if (updatedComment != null) {
    updatedData['comment'] = updatedComment;
  }
  if (updatedRating != null) {
    updatedData['rating'] = updatedRating;
  }

  if (updatedData.isEmpty) {
    print('Güncellenecek veri yok!');
    return false;
  }

  final response = await http.patch(
    Uri.parse('$baseUrl/reviews/$reviewId/'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(updatedData),
  );

  if (response.statusCode == 200) {
    print('Yorum başarıyla güncellendi.');
    return true;
  } else {
    print('Yorum güncelleme hatası: ${response.statusCode} - ${response.body}');
    return false;
  }
}


// yorum ekleme
static Future<bool> _addReview(int placeId, String comment, int rating) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) throw Exception("Token bulunamadı. Giriş yapılmamış.");

  final url = Uri.parse('$baseUrl/places/$placeId/add_review/');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'comment': comment,
      'rating': rating,
    }),
  );

  if (response.statusCode == 201) {
    return true;
  } else if (response.statusCode == 400) {
    final body = jsonDecode(response.body);
    throw Exception(body['error'] ?? "Yorum eklenemedi.");
  } else {
    throw Exception("Sunucu hatası: ${response.statusCode}");
  }
}

}
