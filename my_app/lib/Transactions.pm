use strict;

package Transactions;

use Mojo::Base 'Mojolicious', -signatures;
use Scalar::Util qw(looks_like_number);
use POSIX qw(strftime);

# store the balance
my $balance = 0;

sub new {
    my $class = shift;

    my $self = {
        transactions => []
    };

    bless $self, $class;

    return $self;
}

sub get_all {
    my ($self) = @_;

    return @{$self->{transactions}};
}

sub get_transaction_by_id {
    my ($self, $id) = @_;

    my $transactionFound = '';
    foreach my $transaction (@{$self->{transactions}}) {
        if( $transaction->{"id"} eq $id ) {
            $transactionFound = $transaction;
            last;
        };
    }

    return $transactionFound;
}

sub add_transaction {
    my ($self, $params) = @_;

    if(! $self->looks_params_good($params)) {
        return ("400", "BAD REQUEST")
    }

    if(! $self->can_add_transaction($params)) {
        return ("400", "CAN NOT PROCESS THE OPERATION - BALANCE IS NOT ENOUGH")
    }

    push(@{$self->{transactions}}, {
        id            => "uuid-".int(rand(1000)), # for some reason i am not able to use UUID::Tiny to generate the uuid
        type          => $params->{"type"},
        amount        => $params->{"amount"},
        effectiveDate => strftime("%FT%T", localtime(time)) . sprintf ".%03d" # do not want to include DateTime just for that
    });

    return ("200", "");

}

sub looks_params_good {
    my ($self, $params) = @_;

    return
        ($params->{"type"} eq "credit" || $params->{"type"} eq "debit")
     && (looks_like_number($params->{"amount"}));

}

sub can_add_transaction {
    my ($self, $params) = @_;

    my $amount = $params->{"amount"};

    my $can_add_transaction = '';
    if($params->{type} eq 'credit') {
        $balance += $amount;
        $can_add_transaction = 1;
    } else {
        if($amount <= $balance) {
            $balance -= $amount;
            $can_add_transaction = 1;
        } else {
            $can_add_transaction = 0;
        }
    }

    return $can_add_transaction;
}

1;

