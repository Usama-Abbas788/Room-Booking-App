import 'package:cloudinary_sdk/cloudinary_sdk.dart';

class MediaRepository{
  late Cloudinary cloudinary;
  MediaRepository(){
    cloudinary = Cloudinary.full(
      apiKey: '256644288328244',
      apiSecret: 'tLW3XonkTggINZkMkEfgDG_15ms',
      cloudName: 'dbawboqzl',
    );
  }
  Future<CloudinaryResponse> uploadImage(String path){
    return cloudinary.uploadResource(CloudinaryUploadResource(
      filePath: path,
      resourceType: CloudinaryResourceType.image,
    ));
  }
}