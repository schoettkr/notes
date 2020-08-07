/*
 * @class Person - a class that represents a bank account
 */
public class Account {
    private Person owner;
    private int password;
    private int accountNumber;
    private float accountBalance;

    /*
     * @func Account(int accountNumber, String Vorname, String Nachname, int password)
     *
     * @param   accountNumber : int     - The number of the bank account
     * @param   firstName : String      - the first name of the owner
     * @param   lastName : String       - the last name of the owner
     * @param   password : int          - the password of the account [!not encrypted]
     *
     */
    public Account(int accountNumber, String firstName, String lastName, int password){
        this.owner = new Person(firstName, lastName);
        this.password = password;
        this.accountNumber = accountNumber;
        this.accountBalance = 100;
    }

    /*
     * @func isSameAccount(int accountNumber) : boolean
     *
     * @param   accountNumber : int     - The number of the checking account
     *
     * @return  true    - If the accountNumber == this.accountNumber
     *          false   - otherwise
     */
    public boolean isSameAccount(int accountNumber){
        return this.accountNumber == accountNumber;
    }

    /*
     * @func verification(int password) : boolean
     *
     * @param   password : int      - the password for the account [!not encrypted]
     *
     * @return  true    - If access is granted
     *          false   - otherwise
     */
    public boolean verification(int password){
        return this.password == password;
    }

    /*
     * @func getOwner() : String
     *
     * @return Name of the Owner, formatted
     */
    public String getOwner(){
        return owner.getName();
    }

    /*
     * @func pay(float amount)
     *
     * @param   amount : float      - the amount which will be transfered to the accountBalance
     */
    private void pay(float amount){
        this.accountBalance = this.accountBalance + amount;
    }

    /*
     * @func isPayable(float amount) : boolean
     *
     * @param   amount : float      - the amount whcih should be payed from this account
     *
     * @return  true    - If amount is payable
     *          false   - otherwise
     */
    private boolean isPayable(float amount){
        return this.accountBalance >= amount;
    }

    /*
     * @func deposit(float amount)
     *
     * @param amount: float     - amount which will be deposed to the account
     */
    public void deposit(float amount){
        if(amount<0){
            return;
        }
        pay(amount);
    }

    /*
     * @func payOff(float amount) : bool
     *
     * @param amount: float     - amount which will be payed by the account
     *
     * @return  true    - If amount was payed
     *          false   - otherwise
     */
    public boolean payOff(float amount){
        if(!isPayable(amount)){
            return false;
        }
        pay(-amount);
        return true;
    }

    /*
     * @func getBalance() : float
     *
     * @return  the balance of the account in â‚¬
     */
    public float getBalance(){
        return accountBalance;
    }

    /*
     * @func getAccountNumber() : int
     *
     * @return  the account Number
     */
    public int getAccountNumber(){
        return accountNumber;
    }
}
