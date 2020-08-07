
public class Scopes {
    static class SubKlasse{
        public static int number = 5;
    }

    public int number = 3;

    public void scope_func(int number){

        System.out.println("number = " + number);

        System.out.println("this.number = " + this.number);

        System.out.println("SubKlasse.number = " + SubKlasse.number);

        System.out.println("Scopes.SubKlasse.number = " + Scopes.SubKlasse.number);

        number = 10;
    }

    public void scope_func(Integer number){

        System.out.println("number = " + number);

        System.out.println("this.number = " + this.number);

        System.out.println("SubKlasse.number = " + SubKlasse.number);

        System.out.println("Scopes.SubKlasse.number = " + Scopes.SubKlasse.number);

        number = 10;
    }


    public static void main(String[] args){
        Scopes instance = new Scopes();

        int number = 3;
        Integer number_Integer = 3;

        instance.scope_func(number);
        System.out.println("");

        instance.scope_func(number);
        System.out.println("");
        System.out.println("");

        instance.scope_func(number_Integer);
        System.out.println("");

        instance.scope_func(number_Integer);
        System.out.println("");

        System.out.println("instance.number = " + instance.number);


        System.out.println("SubKlasse.number = " + SubKlasse.number);

        System.out.println("Scopes.SubKlasse.number = " + Scopes.SubKlasse.number);
    }
}
