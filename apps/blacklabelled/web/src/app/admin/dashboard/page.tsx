import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { getAdminStats } from "@/lib/admin-actions";

export default async function DashboardPage() {
  const stats = await getAdminStats();

  const items = [
    { title: "Projects", value: stats.products, icon: "\u{1F4E6}" },
    { title: "Categories", value: stats.categories, icon: "\u{1F3F7}\uFE0F" },
    { title: "Images", value: stats.images, icon: "\u{1F5BC}\uFE0F" },
    { title: "Magazines", value: stats.magazines, icon: "\u{1F4D6}" },
  ];

  return (
    <div>
      <h1 className="mb-8 text-2xl font-bold text-zinc-100">Dashboard</h1>

      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
        {items.map((stat) => (
          <Card
            key={stat.title}
            className="border-zinc-800 bg-zinc-900 text-zinc-100"
          >
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium text-zinc-400">
                {stat.title}
              </CardTitle>
              <span className="text-2xl">{stat.icon}</span>
            </CardHeader>
            <CardContent>
              <p className="text-3xl font-bold">{stat.value}</p>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
