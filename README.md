# blurhash

This library is a [Blurhash](https://github.com/woltapp/blurhash/blob/master/Algorithm.md) algorithm implementation for dart. For more information or other implementations go to https://github.com/woltapp/blurhash.

Instead of showing boring placeholders, just show an idea of the picture while the actual picture is loading! Images can be converted to Base83 on your backend or while uploading in the frontend. Afterwards, you can send the Base83 string to your frontend. The client can then decode the Base83 string and draw the blurred image.

|            | Original                         | Blurred                          |
| ---------- |:------------------------------:| :-----------------------------:|
| **Image**  | <img src="resources/unsplash-image.jpg" alt="original" width="210" height=130/>             |<img src="resources/blurred.jpg" alt="original" width="255" height=130/> |

Based on the hash `q.NK3Mt7WrofayazbHj[l.TkCWBWCj[j@f6azIUWXjZWBWCjsoLayM{ofazayjZa#Wqj[kCWBj[bHWXj[jZWVt7WCs:ofa}axjZay`

##### Example usage
See the example in [example_main](example/lib/example_extended.dart)

<img src="resources/blur.gif" alt="original" width="255"/>

## Getting started
Include the library in your project. Then call the decoder with a valid Base83 string

```Dart
Image.memory(blurhash.Decoder.decode(hash, 300, 200))
```


Credits go to [Dag Ågren](https://github.com/DagAgren) / [Wolt](https://github.com/woltapp) for this idea.