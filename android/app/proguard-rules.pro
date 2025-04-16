# Gson uses generic type information stored in a class file when working with fields.
# Proguard removes such information by default, so configure it to keep all of it.
-ignorewarnings
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes JavascriptInterface

-keepclassmembers class **.R$raw { <fields>; }
