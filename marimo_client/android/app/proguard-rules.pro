# ✅ 기존 keep 룰 유지
-keep class org.tensorflow.** { *; }
-keep class com.google.mediapipe.** { *; }
-keep class com.google.protobuf.** { *; }
-dontwarn org.tensorflow.**
-dontwarn com.google.mediapipe.**
-dontwarn com.google.protobuf.**

# ✅ Mediapipe image 관련 누락된 클래스 보완
-keep class com.google.mediapipe.framework.image.** { *; }
-dontwarn com.google.mediapipe.framework.image.**

# ✅ Protobuf 내부 사용되는 어노테이션 및 reflection 보호
-keepattributes *Annotation*
-keep class javax.lang.model.** { *; }
-dontwarn javax.lang.model.**

# ✅ protobuf generated code 보완
-keepclassmembers class * {
    @com.google.protobuf.** <fields>;
    @com.google.protobuf.** <methods>;
}
-keep @interface com.google.protobuf.**

# ✅ AutoValue 관련 보완 (Mediapipe 내부에서 사용됨)
-dontwarn autovalue.shaded.**
-keep class autovalue.shaded.** { *; }

# ✅ generated missing_rules.txt 내용 반영
-dontwarn com.google.protobuf.Internal$ProtoMethodMayReturnNull
-dontwarn com.google.protobuf.Internal$ProtoNonnullApi
-dontwarn com.google.protobuf.ProtoField
-dontwarn com.google.protobuf.ProtoPresenceBits
-dontwarn com.google.protobuf.ProtoPresenceCheckedField
-dontwarn javax.lang.model.SourceVersion
-dontwarn javax.lang.model.element.Element
-dontwarn javax.lang.model.element.ElementKind
-dontwarn javax.lang.model.element.Modifier
-dontwarn javax.lang.model.type.TypeMirror
-dontwarn javax.lang.model.type.TypeVisitor
-dontwarn javax.lang.model.util.SimpleTypeVisitor8
