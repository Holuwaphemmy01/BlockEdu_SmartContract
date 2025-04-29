
// Module: blockedu_contract{

#[allow(unused_use)]

module blockedu_contract::blockedu_contract{


// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
   use std::vector;
    use std::string;



    public struct User has copy, drop, store {
        first_name: string::String,
        last_name: string::String,
        user_address: string::String,
    }

    public struct UserRegistry has key {
        id: UID,
        users: vector<User>,
    }


    public fun add_user(
        registry: &mut UserRegistry,
        first_name: string::String,
        last_name: string::String,
        user_address: string::String
    ) {
        let user = User {
            first_name,
            last_name,
            user_address
        };
        vector::push_back(&mut registry.users, user);
    }

}