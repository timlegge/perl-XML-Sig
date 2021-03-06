use strict;
use warnings;



use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "A toolkit to help sign and verify XML Digital Signatures.",
  "AUTHOR" => "Original Author: Byrne Reese <byrne\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "XML-Sig",
  "LICENSE" => "perl",
  "NAME" => "XML::Sig",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Class::Accessor" => 0,
    "Crypt::OpenSSL::Bignum" => 0,
    "Crypt::OpenSSL::DSA" => 0,
    "Crypt::OpenSSL::RSA" => 0,
    "Crypt::OpenSSL::X509" => 0,
    "Digest::SHA" => 0,
    "Exporter" => 0,
    "MIME::Base64" => 0,
    "XML::LibXML" => 0,
    "base" => 0,
    "constant" => 0,
    "strict" => 0,
    "vars" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "File::Which" => 0,
    "Test::Exception" => 0,
    "Test::More" => 0
  },
  "VERSION" => "0.38",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Class::Accessor" => 0,
  "Crypt::OpenSSL::Bignum" => 0,
  "Crypt::OpenSSL::DSA" => 0,
  "Crypt::OpenSSL::RSA" => 0,
  "Crypt::OpenSSL::X509" => 0,
  "Digest::SHA" => 0,
  "Exporter" => 0,
  "File::Which" => 0,
  "MIME::Base64" => 0,
  "Test::Exception" => 0,
  "Test::More" => 0,
  "XML::LibXML" => 0,
  "base" => 0,
  "constant" => 0,
  "strict" => 0,
  "vars" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
