import { uiInstallMarkdown } from "@/lib/storybook-install-docs";

import TogeButton from "./TogeButton.vue";

const meta = {
  title: "UI/TogeButton",
  component: TogeButton,
  tags: ["autodocs"],
  parameters: {
    docs: {
      description: {
        component: uiInstallMarkdown("toge-button"),
      },
    },
  },
  argTypes: {
    variant: {
      control: "select",
      options: [
        "default",
        "destructive",
        "outline",
        "secondary",
        "ghost",
        "link",
      ],
    },
    size: {
      control: "select",
      options: ["default", "sm", "lg", "icon", "icon-sm", "icon-lg"],
    },
  },
};

export default meta;

export const Default = {
  render: (args) => ({
    components: { TogeButton },
    setup() {
      return { args };
    },
    template: '<TogeButton v-bind="args">Label</TogeButton>',
  }),
};

export const Destructive = {
  args: {
    variant: "destructive",
  },
  render: (args) => ({
    components: { TogeButton },
    setup() {
      return { args };
    },
    template: '<TogeButton v-bind="args">Delete</TogeButton>',
  }),
};
