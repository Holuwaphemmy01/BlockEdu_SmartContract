// #[allow(unused_use)]
// module blockedu_contract::blockedu_contract {
//
//     use sui::clock::{Self, Clock};
//     use std::string;
//     use sui::object::{Self, UID};
//     use sui::tx_context::TxContext;
//
//
//     public struct User has copy, drop, store {
//         first_name: string::String,
//         last_name: string::String,
//         institution_name: string::String,
//         institution_id: string::String,
//         blob_id: string::String,
//         created_at: u64,
//     }
//
//     public struct UserRegistry has key {
//         id: UID,
//         users: vector<User>,
//     }
//
//     public fun new_user_registry(ctx: &mut TxContext): UserRegistry {
//         UserRegistry {
//             id: object::new(ctx),
//             users: vector::empty<User>(),
//         }
//     }
//
//     public fun add_user(
//         registry: &mut UserRegistry,
//         clock: &Clock,
//         first_name: string::String,
//         last_name: string::String,
//         institution_name: string::String,
//         institution_id: string::String,
//         blob_id: string::String,
//     ) {
//         let user = User {
//             first_name,
//             last_name,
//             institution_name,
//             institution_id,
//             blob_id,
//             created_at: clock::timestamp_ms(clock),
//         };
//         vector::push_back(&mut registry.users, user);
//     }
//
//     public fun get_user_count(registry: &UserRegistry): u64 {
//         vector::length(&registry.users)
//     }
//
//     public fun get_user_at_index(registry: &UserRegistry, index: u64): &User {
//         vector::borrow(&registry.users, index)
//     }
//
//     public fun get_first_name(user: &User): &string::String {
//         &user.first_name
//     }
//
//     public fun get_last_name(user: &User): &string::String {
//         &user.last_name
//     }
//
//     public fun get_institution_name(user: &User): &string::String {
//         &user.institution_name
//     }
//
//     public fun get_institution_id(user: &User): &string::String {
//         &user.institution_id
//     }
//
//     public fun get_blob_id(user: &User): &string::String {
//         &user.blob_id
//     }
//
//     public fun get_created_at(user: &User): u64 {
//         user.created_at
//     }
//
//     public fun destroy_user_registry(registry: UserRegistry) {
//         let UserRegistry {
//             id,
//             users: _,
//         } = registry;
//         object::delete(id);
//     }
//
//
// }



#[allow(duplicate_alias)]
module blockedu_contract::blockedu_contract {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::clock::{Self, Clock};
    use std::string;
    use sui::event;

    // Admin capability to restrict access
    public struct AdminCap has key {
        id: UID,
    }

    // User struct
    public struct User has key, store {
        id: UID,
        first_name: string::String,
        last_name: string::String,
        institution_name: string::String,
        institution_id: string::String,
        blob_id: string::String,
        created_at: u64,
    }

    // Event for user addition
    public struct UserAdded has copy, drop {
        user_id: object::ID,
    }

    // Initialize AdminCap on contract publication
    fun init(ctx: &mut TxContext) {
        let admin_cap = AdminCap { id: object::new(ctx) };
        transfer::transfer(admin_cap, tx_context::sender(ctx));
    }

    #[allow(lint(self_transfer))]
    public fun add_user(
        _admin_cap: &AdminCap,
        first_name: string::String,
        last_name: string::String,
        institution_name: string::String,
        institution_id: string::String,
        blob_id: string::String,
        clock: &Clock,
        ctx: &mut TxContext,
    ) {
        let user = User {
            id: object::new(ctx),
            first_name,
            last_name,
            institution_name,
            institution_id,
            blob_id,
            created_at: clock::timestamp_ms(clock),
        };
        let user_id = object::id(&user);
        transfer::transfer(user, tx_context::sender(ctx));
        event::emit(UserAdded { user_id });
    }

    // Getter functions
    public fun get_first_name(user: &User): &string::String { &user.first_name }
    public fun get_last_name(user: &User): &string::String { &user.last_name }
    public fun get_institution_name(user: &User): &string::String { &user.institution_name }
    public fun get_institution_id(user: &User): &string::String { &user.institution_id }
    public fun get_blob_id(user: &User): &string::String { &user.blob_id }
    public fun get_created_at(user: &User): u64 { user.created_at }

    // Test-only function to create AdminCap
    #[test_only]
    public fun create_admin_cap_for_testing(ctx: &mut TxContext) {
        let admin_cap = AdminCap { id: object::new(ctx) };
        transfer::transfer(admin_cap, tx_context::sender(ctx));
    }
}