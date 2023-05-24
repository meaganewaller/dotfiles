import { KarabinerComplexModifications, Key } from "https://deno.land/x/karabiner@v0.2.0/karabiner.ts";
import { hyper, hyperCmd } from "./lib/hyper";

const mods = new KarabinerComplexModifications({
  parameters: {
    "basic.simultaneous_threshold_milliseconds": 50,
    "basic.to_delayed_action_delay_milliseconds": 250,
    "basic.to_if_alone_timeout_milliseconds": 500,
    "basic.to_if_held_down_threshold_milliseconds": 50,
    "mouse_motion_to_scroll.speed": 100,
  },
})

mods.addRule({
  description: "Vim key bindings",
  manipulators: [
    hyper("h", "left_arrow"),
    hyper("l", "right_arrow"),
    hyper("k", "up_arrow"),
    hyper("j", "down_arrow"),
  ],
});

const vimTuples: [Key, Key][] = [
  ["k", "up_arrow"],
  ["j", "down_arrow"],
  ["h", "left_arrow"],
  ["l", "right_arrow"],
];

vimTuples.forEach(([keyFrom, keyTo]) => {
  mods.addRule({
    description: `Vim Key Bindings ${keyFrom} -> ${keyTo}`,
    manipulators: [
      hyper(keyFrom, keyTo),
      hyperCmd(keyFrom, keyTo, { modifiers: ["left_shift"] }),
    ],
  });
});

// Symbols
/* mods.addRule({ */
/*   description: `Brackets`, */
/*   manipulators: [ */
/*     hyper("e", "9", { modifiers: ["left_shift"]}), */
/*     hyper("r", "0", { modifiers: [ "left_shift" ] }), */
/*     hyper("i", "open_bracket", { modifiers: [ "left_shift" ] }), */
/*     hyper("o", "close_bracket", { modifiers: [ "left_shift" ] }), */
/*     hyperCmd("i", "open_bracket"), */
/*     hyperCmd("o", "close_bracket"), */
/*   ], */
/* }); */

/* mods.addRule({ */
/*   description: `Semicolon / Colon`, */
/*   manipulators: [ */
/*     // Semicolon */
/*     hyper("w", "semicolon", { modifiers: [ "left_shift" ] }), */
/*     hyper("q", "semicolon"), */
/*   ], */
/* }); */
/**/
/* mods.addRule({ */
/*   description: `Quote / Double Quote`, */
/*   manipulators: [ */
/*     // Quote / Double Quote */
/*     hyper("t", "quote"), */
/*     hyper("y", "quote", { modifiers: [ "left_shift" ] }), */
/*   ], */
/* }); */
/**/
/* mods.addRule({ */
/*   description: `Slash`, */
/*   manipulators: [ */
/*     hyper("backslash", "slash"), */
/*   ] */
/* }) */
/**/
/* mods.addRule({ */
/*   description: `hyphen / Underscore`, */
/*   manipulators: [ */
/*     // hyphen / Underscore */
/*     hyper("f", "hyphen"), */
/*     hyper("g", "hyphen", { modifiers: [ "left_shift" ] }), */
/*   ], */
/* }); */

mods.addRule({
  description: "Swap Command and Option on Apple keyboards",
  manipulators: [
    {
      type: "basic",
      from: {
        key_code: "left_command",
      },
      to: [
        {
          key_code: "left_option",
        },
      ],
    },
  ],
})

mods.addRule({
  description: "Swap Option and Command on Apple keyboards",
  manipulators: [
    {
      type: "basic",
      from: {
        key_code: "left_option",
      },
      to: [
        {
          key_code: "left_command",
        },
      ],
    },
  ],
})

// // Block left-handed shift + left handed key
// const leftHandedKeys: Key[] = [
// 	"1",
// 	"2",
// 	"3",
// 	"4",
// 	"5",
// 	"q",
// 	"w",
// 	"e",
// 	"r",
// 	"t",
// 	"a",
// 	"s",
// 	"d",
// 	"f",
// 	"g",
// 	"z",
// 	"x",
// 	"c",
// 	"v",
// 	"grave_accent_and_tilde",
// ];
// leftHandedKeys.forEach((element) => {
// 	mods.addRule({
// 		description: `Block left-handed shift + ${element}`,
// 		manipulators: [
// 			{
// 				from: {
// 					key_code: element,
// 					modifiers: { mandatory: [ "left_shift" ] },
// 				},
// 				to: [ { key_code: "vk_none" } ],
// 				type: "basic",
// 			},
// 		],
// 	});
// });

// // Block left-handed shift + left handed key
// const rightHandedKeys: Key[] = [
// 	"7",
// 	"8",
// 	"9",
// 	"0",
// 	"hyphen",
// 	"equal_sign",
// 	"semicolon",
// 	"quote",
// 	"open_bracket",
// 	"backslash",
// 	"close_bracket",
// 	"slash",
// 	"period",
// 	"comma",
// 	"slash",
// 	"non_us_backslash",
// 	"u",
// 	"i",
// 	"o",
// 	"p",
// 	"j",
// 	"k",
// 	"l",
// 	"n",
// 	"m",
// ];

// rightHandedKeys.forEach((element) => {
// 	mods.addRule({
// 		description: `Block right-handed shift + ${element}`,
// 		manipulators: [
// 			{
// 				from: {
// 					key_code: element,
// 					modifiers: { mandatory: [ "right_shift" ] },
// 				},
// 				to: [ { key_code: "vk_none" } ],
// 				type: "basic",
// 			},
// 		],
// 	});
// });

mods.addRule({
  description: "Caps Lock -> Control as modifier -> Escape if pressed alone",
  manipulators: [
    {
      from: { key_code: "caps_lock", modifiers: { optional: ["any"] } },
      to: [{ key_code: "right_control" }],
      to_if_alone: [{ key_code: "escape" }],
      type: "basic",
    },
  ],
})

mods.addRule({
  description: "Change ctrl+delete to forward delete",
  manipulators: [
    {
      from: {
        key_code: "delete_or_backspace",
        modifiers: {
          mandatory: ["control"],
          optional: ["caps_lock", "option"],
        },
      },
      to: [
        {
          key_code: "delete_forward"
        },
      ],
      type: "basic"
    },
  ]
})

mods.writeToProfile("Default")
