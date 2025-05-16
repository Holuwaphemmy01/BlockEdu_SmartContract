#[test_only]
module blockedu_contract::blockedu_contract_tests {
    use sui::test_scenario;
    use blockedu_contract::blockedu_contract::{Self, AdminCap, User};
    use sui::clock;
    use std::string;

    #[test]
    fun test_add_user() {
        let admin_address = @0xA;
        let mut scenario = test_scenario::begin(admin_address);


        test_scenario::next_tx(&mut scenario, admin_address);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            blockedu_contract::create_admin_cap_for_testing(ctx);
        };


        test_scenario::next_tx(&mut scenario, admin_address);
        {
            let admin_cap = test_scenario::take_from_sender<AdminCap>(&scenario);
            let mut clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
            clock::set_for_testing(&mut clock, 1234567890);
            blockedu_contract::add_user(
                &admin_cap,
                string::utf8(b"John"),
                string::utf8(b"Doe"),
                string::utf8(b"Semicolon"),
                string::utf8(b"12345"),
                string::utf8(b"blob123"),
                &clock,
                test_scenario::ctx(&mut scenario)
            );
            test_scenario::return_to_sender(&scenario, admin_cap);
            clock::destroy_for_testing(clock);
        };


        test_scenario::next_tx(&mut scenario, admin_address);
        {
            let user = test_scenario::take_from_sender<User>(&scenario);
            assert!(*blockedu_contract::get_first_name(&user) == string::utf8(b"John"), 101);
            assert!(*blockedu_contract::get_last_name(&user) == string::utf8(b"Doe"), 102);
            assert!(*blockedu_contract::get_institution_name(&user) == string::utf8(b"Semicolon"), 103);
            assert!(*blockedu_contract::get_institution_id(&user) == string::utf8(b"12345"), 104);
            assert!(*blockedu_contract::get_blob_id(&user) == string::utf8(b"blob123"), 105);
            assert!(blockedu_contract::get_created_at(&user) == 1234567890, 106);
            test_scenario::return_to_sender(&scenario, user);
        };

        test_scenario::end(scenario);
    }
}