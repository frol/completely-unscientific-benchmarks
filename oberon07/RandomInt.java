import java.util.Random;

public class RandomInt {

public static void Init() { rand = new Random(); }

public static int NextInt() { return rand.nextInt(); }

private static Random rand;

}
