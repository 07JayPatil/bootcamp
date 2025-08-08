module MyModule::CharityDonationTracker {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct to track charity details.
    struct Charity has key, store {
        name: vector<u8>,   // Charity name
        total_donations: u64 // Total tokens donated
    }

    /// Initialize a charity with a name.
    public fun create_charity(admin: &signer, name: vector<u8>) {
        let charity = Charity {
            name,
            total_donations: 0
        };
        move_to(admin, charity);
    }

    /// Donate AptosCoin to the charity.
    public fun donate(donor: &signer, charity_addr: address, amount: u64) acquires Charity {
        let charity = borrow_global_mut<Charity>(charity_addr);

        // Transfer coins from donor to charity address
        let donation = coin::withdraw<AptosCoin>(donor, amount);
        coin::deposit<AptosCoin>(charity_addr, donation);

        // Update total donations
        charity.total_donations = charity.total_donations + amount;
    }
}
