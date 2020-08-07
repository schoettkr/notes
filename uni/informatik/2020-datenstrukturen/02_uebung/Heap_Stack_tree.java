public class Heap_stack_tree {

    public static class Node
    {
        public String data;
        public Node childs[];

        public Node(String data)
        {
            this.childs = new Node[2];
            this.data = data;
        }

        public Node add(String data)
        {
            int i = 0;

            while(childs[i] != null)
                {
                    i++;
                }

            childs[i] = new Node(data);
            return childs[i];
        }
    }

    public static void fill(Node n)
    {
        Node l = n.add("B");
        Node r = n.add("C");
        l.add("D");
        l.add("E");
    }
    public static void main(String[] args)
    {

        {

            Node root = new Node("root");
            root.add("#1");
            root.add("#2");
            root.add("#3");
        }

        {

            Node root = new Node("root");
            Node A = root.add("A");
            fill(A);
        }


    }
}
