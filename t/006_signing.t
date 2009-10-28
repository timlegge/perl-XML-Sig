# -*- perl -*-

use strict;
use warnings;

use Test::More tests => 7;
use Test::Exception;
use MIME::Base64;

BEGIN {
    use_ok( 'XML::Sig' );
}

my $signed_b64 = 'PD94bWwgdmVyc2lvbj0iMS4wIj8+Cjxmb28+PGJhcj4xMjM8L2Jhcj48U2lnbmF0dXJlIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj4KICAgICAgICAgICAgPFNpZ25lZEluZm8geG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiIHhtbG5zOnNhbWxwPSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6cHJvdG9jb2wiIHhtbG5zOnhlbmM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jIyI+CiAgICAgICAgICAgICAgICA8Q2Fub25pY2FsaXphdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RSLzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1I1dpdGhDb21tZW50cyIgLz4KICAgICAgICAgICAgICAgIDxTaWduYXR1cmVNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjcnNhLXNoYTEiIC8+CiAgICAgICAgICAgICAgICA8UmVmZXJlbmNlIFVSST0iIj4KICAgICAgICAgICAgICAgICAgICAgICAgPFRyYW5zZm9ybXM+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICA8VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiIC8+CiAgICAgICAgICAgICAgICAgICAgICAgIDwvVHJhbnNmb3Jtcz4KICAgICAgICAgICAgICAgICAgICAgICAgPERpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNzaGExIiAvPgogICAgICAgICAgICAgICAgICAgICAgICA8RGlnZXN0VmFsdWU+anIwTTZpZ0RMREZ0OC94Z1pxRysxd2hkNmk0PTwvRGlnZXN0VmFsdWU+CiAgICAgICAgICAgICAgICAgICAgPC9SZWZlcmVuY2U+CiAgICAgICAgICAgIDwvU2lnbmVkSW5mbz4KICAgICAgICAgICAgPFNpZ25hdHVyZVZhbHVlPmQ2VkYvRTdvSGNJRllNQ3VYWEdIeUk0bHMrZC9FUTB5NWlhVTdWZnNNRWNqcVdXcDY4VkQ1Vlh0cmtWNXo0bkUwS0ViYVBCUmRVRXcKYW15eWFaNDE4R1RWRUhQd29SbFZzVDVOdWxCOTF4cG1hN21RNGZUTFRWZW56U1hrdThJZE1tUkdzekJSOEE5WlhvWHZ2U0FPTDZNQgpUa2V2RFhoWmdEQkNxLzJjV3d1a2RLcFFEandiTnBkdXdsWFVQS2dTa1F3aHpiY3Q3TkFNWk9CWUhSbDJDTUdhSVFqdFdlMjd0ZjRyClBPYTdRczloTS9pSkMxZzFZYmkrWXFRUmlxekxpOUREeGhMSjIrM05nWStTSmg5c043bi9WQjhtNkw5VHQxV2VSZWYzbXdyaGlUbzkKMTk1TlNscFhYVG94aDhVRUlsWXhaTEh5amRDVU43aUFYVThhL3c9PQo8L1NpZ25hdHVyZVZhbHVlPgogICAgICAgICAgICA8S2V5SW5mbz48S2V5VmFsdWU+PFJTQUtleVZhbHVlPjxNb2R1bHVzPjFiK20zN3UzWHlhd2gyQXJWOHR4TGVpMjUxcDAzQ1hia1Z1V2FKdTlDOGVIeTFwdTg3YmN0aGkrVDVXZGxDUEtEN0tHdGtLbjl2cWk0QkpCWmNHL1kxMGU4S1dWbFhETGc5Z2liTjVoYjBBZ2FlM2kxY0NKVHFxblEwS2E4dzFYQUJ0YnhUaW1TMUIwYU8xellXNmQrVVlsMHhJZUFPUHNHTWZXZXUxTmdMQ2haUXRvbjEvTnJKc0t3ek1hUXkxVkk4bTRnVWxlaXQ5WjhtYno5Yk5Nc2hkZ1lFWjlvQzRiSG4vU25BNEZ2UWwxZmpXeVRwekwvYVdGL2JFelM2UWQ4SUJrN3loY1dSSkFHZFhUV3R3aVg0bVhiNGgvMnNkclNOdnlPc2Qvc2hDZk9TTXNmMFRYK09kbGJIMDc5QXN4T3dvVWpsemp1S2RDaUZQZFU2eUFKdz09PC9Nb2R1bHVzPjxFeHBvbmVudD5Jdz09PC9FeHBvbmVudD48L1JTQUtleVZhbHVlPjwvS2V5VmFsdWU+PC9LZXlJbmZvPgogICAgICAgIDwvU2lnbmF0dXJlPjwvZm9vPg==';
my $signed2_b64 = 'PGZvbyBJRD0iYWJjIj48YmFyPjEyMzwvYmFyPjxTaWduYXR1cmUgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiPgogICAgICAgICAgICA8U2lnbmVkSW5mbyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyIgeG1sbnM6c2FtbHA9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDpwcm90b2NvbCIgeG1sbnM6eGVuYz0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjIj4KICAgICAgICAgICAgICAgIDxDYW5vbmljYWxpemF0aW9uTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvVFIvMjAwMS9SRUMteG1sLWMxNG4tMjAwMTAzMTUjV2l0aENvbW1lbnRzIiAvPgogICAgICAgICAgICAgICAgPFNpZ25hdHVyZU1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNyc2Etc2hhMSIgLz4KICAgICAgICAgICAgICAgIDxSZWZlcmVuY2UgVVJJPSIjYWJjIj4KICAgICAgICAgICAgICAgICAgICAgICAgPFRyYW5zZm9ybXM+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICA8VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiIC8+CiAgICAgICAgICAgICAgICAgICAgICAgIDwvVHJhbnNmb3Jtcz4KICAgICAgICAgICAgICAgICAgICAgICAgPERpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNzaGExIiAvPgogICAgICAgICAgICAgICAgICAgICAgICA8RGlnZXN0VmFsdWU+OWtwbXJ2djNwZVZKcE5TVFJ5Y3JWK2plSFZZPTwvRGlnZXN0VmFsdWU+CiAgICAgICAgICAgICAgICAgICAgPC9SZWZlcmVuY2U+CiAgICAgICAgICAgIDwvU2lnbmVkSW5mbz4KICAgICAgICAgICAgPFNpZ25hdHVyZVZhbHVlPkhYVUJuTWdQSmYvL2o0aWhhV25heWxOd0FSNUF6REZZODNIbGpGSWxMbVRxWDF3MUM3MlpUdVJPYnZZdmU4VE5FYlZzUWxUUWtqNFIKaGlZMHBnSU1RVWI3NUdMWUZ0YytmMFltQlpmNXJDV1kzTld6bzQzMkQzb2dBdnBFellYRVFQbWljV2UyUW96UWh5YmF6OS93cllraQpYaVhZKzU3ZnFDa2Y3YVQ4QmI2RytmbjdBajhnblpGTGttS3h3Q2R5R3NJWk9JWmRROE1XcGVRcmlmeEJSMGQ4VzFabTZpeDIxV052Ck9OdDU3NWg3VnhMS3c4QkRoTlBTMHA4Q1MzaE9uU2syOXN0cGlETUNIRlB4QXdyYktWTDFrR0RMYUxabjFxOG5OUm1IOG9GeEcxNWwKVW1TM0pYRFpBc3M4Z1poVTdnOVQ0WGxsQ3FqckF2elBMT0ZkZVE9PQo8L1NpZ25hdHVyZVZhbHVlPgogICAgICAgICAgICA8S2V5SW5mbz48WDUwOURhdGE+PFg1MDlDZXJ0aWZpY2F0ZT4KTUlJQklEQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FRMEFNSUlCQ0FLQ0FRRUExYittMzd1M1h5YXdoMkFyVjh0eApMZWkyNTFwMDNDWGJrVnVXYUp1OUM4ZUh5MXB1ODdiY3RoaStUNVdkbENQS0Q3S0d0a0tuOXZxaTRCSkJaY0cvClkxMGU4S1dWbFhETGc5Z2liTjVoYjBBZ2FlM2kxY0NKVHFxblEwS2E4dzFYQUJ0YnhUaW1TMUIwYU8xellXNmQKK1VZbDB4SWVBT1BzR01mV2V1MU5nTENoWlF0b24xL05ySnNLd3pNYVF5MVZJOG00Z1VsZWl0OVo4bWJ6OWJOTQpzaGRnWUVaOW9DNGJIbi9TbkE0RnZRbDFmald5VHB6TC9hV0YvYkV6UzZRZDhJQms3eWhjV1JKQUdkWFRXdHdpClg0bVhiNGgvMnNkclNOdnlPc2Qvc2hDZk9TTXNmMFRYK09kbGJIMDc5QXN4T3dvVWpsemp1S2RDaUZQZFU2eUEKSndJQkl3PT0KPC9YNTA5Q2VydGlmaWNhdGU+PC9YNTA5RGF0YT48L0tleUluZm8+CiAgICAgICAgPC9TaWduYXR1cmU+PC9mb28+';

my $modulus = '1b+m37u3Xyawh2ArV8txLei251p03CXbkVuWaJu9C8eHy1pu87bcthi+T5WdlCPKD7KGtkKn9vqi4BJBZcG/Y10e8KWVlXDLg9gibN5hb0Agae3i1cCJTqqnQ0Ka8w1XABtbxTimS1B0aO1zYW6d+UYl0xIeAOPsGMfWeu1NgLChZQton1/NrJsKwzMaQy1VI8m4gUleit9Z8mbz9bNMshdgYEZ9oC4bHn/SnA4FvQl1fjWyTpzL/aWF/bEzS6Qd8IBk7yhcWRJAGdXTWtwiX4mXb4h/2sdrSNvyOsd/shCfOSMsf0TX+OdlbH079AsxOwoUjlzjuKdCiFPdU6yAJw==';
my $exponent = 'Iw==';

my $sig = XML::Sig->new( { key => 't/rsa.private.key' } );
isa_ok( $sig, 'XML::Sig' );
my $xml = '<?xml version="1.0"?>'."\n".'<foo ID="abc"><bar>123</bar></foo>';
my $signed = $sig->sign($xml);
ok( encode_base64( $signed,'' ), $signed_b64 );
my $is_valid = $sig->verify( $signed );
ok( $is_valid == 1);

my $sig2 = XML::Sig->new( { key => 't/rsa.private.key', x509 => 1 } );
isa_ok( $sig2, 'XML::Sig' );
my $signed2 = $sig2->sign($xml);
ok( encode_base64( $signed2,'' ), $signed2_b64 );
my $is_valid2 = $sig2->verify( $signed2 );
ok( $is_valid2 == 1 );
