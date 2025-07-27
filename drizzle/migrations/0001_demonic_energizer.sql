PRAGMA foreign_keys=OFF;--> statement-breakpoint
CREATE TABLE `__new_uptime_checks` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`websiteId` integer NOT NULL,
	`timestamp` text NOT NULL,
	`status` integer,
	`responseTime` integer,
	`isUp` integer NOT NULL,
	FOREIGN KEY (`websiteId`) REFERENCES `websites`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
INSERT INTO `__new_uptime_checks`("id", "websiteId", "timestamp", "status", "responseTime", "isUp") SELECT "id", "websiteId", "timestamp", "status", "responseTime", "isUp" FROM `uptime_checks`;--> statement-breakpoint
DROP TABLE `uptime_checks`;--> statement-breakpoint
ALTER TABLE `__new_uptime_checks` RENAME TO `uptime_checks`;--> statement-breakpoint
PRAGMA foreign_keys=ON;