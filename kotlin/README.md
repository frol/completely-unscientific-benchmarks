# Kotlin JVM

## Compile

```
kotlinc -include-runtime -d main-kt.jar ./main-jvm.kt
```

## Execute

```
java -jar main-kt.jar
```

```
java -jar -Xms50M -Xmx50M main-kt.jar
```


# Kotlin Native

## Compile

```
kotlinc-native -opt -o main-kt main.kt
```

## Execute

```
./main-kt.kexe
```
