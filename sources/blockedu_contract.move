
// Module: blockedu_contract{


module blockedu_contract::blockedu_contract{


// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
   use sui::vector;
    use sui::string;



    public struct User has copy, drop, store {
        first_name: string::String,
        last_name: string::String,
        user_address: string::String,
    }

    public struct UserRegistry has key {
        id: UID,
        users: vector<User>,
    }

}