package MIME::Base32;

require 5.005_62;
use strict;
use warnings;

our $VERSION = '0.02'; # $Id: Base32.pm_rev 1.2 2003/05/01 22:00:01 root Exp root $


# Preloaded methods go here.

sub encode{			

	# base32:
	#
	#  modified base64 algorithm with
	#  32 characters set:  0 - 9  A - V
	#
	
	
	$_ = shift @_;
	my( $buffer, $l, $e );

	$_=unpack('B*', $_);
	s/(.....)/000$1/g;
	$l=length;
	if ($l & 7)
	{
		$e = substr($_, $l & ~7);
		$_ = substr($_, 0, $l & ~7);
		$_ .= "000$e" . '0' x (5 - length $e);
	}
	$_=pack('B*', $_);
	tr|\0-\37|0-9A-V|;
	$_;
}

sub decode{
        $_ = shift;
        my( $l );
		
        tr|0-9A-V|\0-\37|;
        $_=unpack('B*', $_);
        s/000(.....)/$1/g;
        $l=length;
					
        # pouzije pouze platnou delku retezce
        $_=substr($_, 0, $l & ~7) if $l & 7;
					
        $_=pack('B*', $_);
}


1;
__END__

=head1 NAME

MIME::Base32 - Base32 encoder / decoder

=head1 SYNOPSIS

  use MIME::Base32;
  $encoded = MIME::Base32::encode($text_or_binary_data);
  $decoded = MIME::Base32::decode($encoded);
					 
=head1 DESCRIPTION

Encode data similar way like MIME::Base64 does. 
  
Main purpose is to create encrypted text used as id or key entry typed-or-submitted by user. It is upper/lowercase safe (not sensitive).

=head1 EXPORT

ALLWAYS NOTHING

=head1 AUTHOR

Daniel Peder, sponsored by Infoset s.r.o., Czech Republic 
<Daniel.Peder@InfoSet.COM> http://www.infoset.com

=head1 SEE ALSO

perl(1), MIME::Base64(3pm).

=cut
