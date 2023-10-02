// 500 character length
const xsmallJson =
    '''{"id":1,"title":"iPhone 9","price":549,"discountPercentage":12.96,"rating":4.69,"stock":94,"brand":"Apple","category":"smartphones"}''';
const smallJson =
    '''{"id":1,"title":"iPhone 9","description":"An apple mobile which is nothing like apple","price":549,"discountPercentage":12.96,"rating":4.69,"stock":94,"brand":"Apple","category":"smartphones","thumbnail":"https://i.dummyjson.com/data/products/1/thumbnail.jpg","images":["https://i.dummyjson.com/data/products/1/1.jpg","https://i.dummyjson.com/data/products/1/2.jpg","https://i.dummyjson.com/data/products/1/3.jpg","https://i.dummyjson.com/data/products/1/4.jpg","https://i.dummyjson.com/data/products/1/thumbnail.jpg"]}''';
final mediumJson = '''[${List.filled(10, smallJson).join(',')}]''';
final largeJson = '''[${List.filled(100, smallJson).join(',')}]''';
final xLargeJson = '''[${List.filled(1000, smallJson).join(',')}]''';
final xxLargeJson = '''[${List.filled(10000, smallJson).join(',')}]''';

final listJson = <String>[
  "[$xsmallJson]",
  "[$smallJson]",
  mediumJson,
  largeJson,
  xLargeJson,
  xxLargeJson,
];
