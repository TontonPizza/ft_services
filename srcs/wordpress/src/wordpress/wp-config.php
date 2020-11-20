<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wp_admin' );

/** MySQL database password */
define( 'DB_PASSWORD', 'admin' );

/** MySQL hostname */
define( 'DB_HOST', '172.18.0.5:3306');

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         't$~H4sopt&4u8muQ5vI/S61pZ5=v~]YVcPo!UxXmT]v(ytq9jT8WS>QiP]})P)k9' );
define( 'SECURE_AUTH_KEY',  'ZM1KhgvWyTSM-8xSCSv{]RA<Orv<]G^!Rs=>EsE;3+FGIkUW5E<PN&aw-aZ(bpYf' );
define( 'LOGGED_IN_KEY',    'C^yJe-eh}2Rm.J852@<__bnWI{BN|Ma|/{7!Fw/r(ke]$0Eitz;lT#zjoz:b/iY>' );
define( 'NONCE_KEY',        '&C-f3k6DWPQb-zrtM`iQg*x%=fvsLP>-]r5,})hXA61rnJ(.m!XM3~S^Mw!1(8us' );
define( 'AUTH_SALT',        '#b7gmC=_y|ZzUS9qSA3QR):4tp3%tu6`o)Kdx)vX/WXP*eRnnf!{Uw]t}8Xv(y!j' );
define( 'SECURE_AUTH_SALT', 'EA=0C}3JCsd3Xl[r}j.*oE4H-Cs0{?=lqKXE5@c}|S|10^7W[neXB=Oxa9qtwJ}j' );
define( 'LOGGED_IN_SALT',   'P/oB[h=T}D#ARk%GK_1Gz1{+G}MyX6s3k}y)-Ast@}AcOT?1$aK<(I9}E(}=ipDd' );
define( 'NONCE_SALT',       '348yZ]fg=sI&mU,Vt<E&eNp+jtO9qVUti(<l3cgCp=](0p>78/-(v1=enl|sb<ec' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
